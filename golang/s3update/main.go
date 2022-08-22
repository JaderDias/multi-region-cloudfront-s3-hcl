package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"

	"example.com/s3update/types"
	"github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest(ctx context.Context, event types.LambdaEvent) error {
	log.Printf("Hello %+v!", event)
	domainName := os.Getenv("DOMAIN_NAME")
	if len(event.Records) == 0 {
		log.Fatalf("no records")
	}

	for _, record := range event.Records {
		uri := fmt.Sprintf("https://%s/%s", domainName, record.S3.Object.Key)
		log.Printf("request: %s", uri)
		_, err := http.Get(uri)
		if err != nil {
			log.Fatalf("request failed: %s", err)
		}
	}

	return nil
}

func main() {
	lambda.Start(HandleRequest)
}
