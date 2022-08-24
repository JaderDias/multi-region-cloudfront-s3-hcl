package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"runtime"
	"strings"

	"github.com/JaderDias/limiter"

	"example.com/s3update/types"
	"github.com/aws/aws-lambda-go/lambda"
)

func Request(domainName, uri string) {
	domainName = strings.TrimSuffix(domainName, ".cloudfront.net")
	numberOfWorkers := runtime.NumCPU() * 4 // optimal number for my use case
	limiter.BoundedConcurrencyWithDoneProcessor(
		numberOfWorkers,
		len(cloudfrontPoPs),
		func(i int) error {
			pop := cloudfrontPoPs[i]
			log.Printf("Requesting %s from %s", uri, pop)
			ips, err := getIPs(domainName, pop)
			if err != nil {
				return fmt.Errorf("error looking up %s: %v", pop, err)
			}

			for _, ip := range ips {
				if ip.To4() == nil {
					// AWS Lambda doesn't support IPv6 outgoing connections
					continue
				}

				client := GetHttpClient(ip)
				response, err := client.Get(uri)
				if err != nil {
					return fmt.Errorf("request for %s ip %s failed: %s", pop, ip, err)
				}

				log.Printf(
					"response for %s status %s x-cache %s x-amz-cf-pop %s",
					ip,
					response.Status,
					response.Header.Get("x-cache"),
					response.Header.Get("x-amz-cf-pop"),
				)
			}

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
		Request(domainName, uri)
	}

	return nil
}

func main() {
	lambda.Start(HandleRequest)
}
