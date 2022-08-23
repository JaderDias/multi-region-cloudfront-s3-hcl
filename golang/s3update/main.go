package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"runtime"
	"strconv"
	"strings"
	"time"

	"encoding/json"

	"github.com/JaderDias/limiter"

	"example.com/s3update/types"
	"github.com/aws/aws-lambda-go/lambda"
)

var ipList = types.IPList{}

const timeout = time.Duration(10 * time.Second)

func Request(cidrs []string, uri string) {
	dialer := &net.Dialer{
		Timeout:   timeout,
		KeepAlive: timeout,
	}
	numberOfWorkers := runtime.NumCPU() * 4 // optimal number for my use case
	limiter.BoundedConcurrencyWithDoneProcessor(
		numberOfWorkers,
		len(cidrs),
		func(i int) error {
			cidr := cidrs[i]
			ip, _, err := net.ParseCIDR(cidr)
			if err != nil {
				return fmt.Errorf("parse cidr %s failed: %s", cidr, err)
			}
			if ip.To4() == nil {
				return fmt.Errorf("AWS Lambdas don't support outgoing IPv6: %s", ip)
			}
			split := strings.Split(ip.String(), ".")
			number, err := strconv.Atoi(split[3])
			if err != nil {
				return fmt.Errorf("parse ip %s failed: %s", ip, err)
			}
			split[3] = strconv.Itoa(number + 1)
			ipStr := strings.Join(split, ".")
			client := &http.Client{
				Transport: &http.Transport{
					DialContext: func(ctx context.Context, network, addr string) (net.Conn, error) {
						addr = fmt.Sprintf("[%s]:443", ipStr)
						log.Printf("new: %s %s", network, addr)
						return dialer.DialContext(ctx, network, addr)
					},
				},
			}

			response, err := client.Get(uri)
			if err != nil {
				return fmt.Errorf("request for %s failed: %s", ipStr, err)
			}

			log.Printf(
				"response for %s status %s x-cache %s x-amz-cf-pop %s",
				ipStr,
				response.Status,
				response.Header.Get("x-cache"),
				response.Header.Get("x-amz-cf-pop"),
			)

			return nil
		},
		func(err error) {
			if err != nil {
				log.Printf("error: %s", err)
			}
		},
	)
}

func HandleRequest(ctx context.Context, event types.LambdaEvent) error {
	log.Printf("Hello %+v!", event)
	domainName := os.Getenv("DOMAIN_NAME")
	if len(event.Records) == 0 {
		log.Fatalf("no records")
	}

	for _, record := range event.Records {
		uri := fmt.Sprintf("https://%s/%s", domainName, record.S3.Object.Key)
		log.Printf("uri: %s", uri)
		log.Println("requesting global ips")
		Request(ipList.Global, uri)
		log.Println("requesting regional ips")
		Request(ipList.Regional, uri)
	}

	return nil
}

func main() {
	response, err := http.Get("https://d7uri8nf7uskq.cloudfront.net/tools/list-cloudfront-ips")
	if err != nil {
		log.Fatalf("request failed: %s", err)
	}

	defer response.Body.Close()
	err = json.NewDecoder(response.Body).Decode(&ipList)
	if err != nil {
		log.Fatalf("decode failed: %s", err)
	}
	lambda.Start(HandleRequest)
}
