package main

import (
	"context"
	"log"
	"os"

	warmup "github.com/JaderDias/cloudfront-warmup"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

var (
	cloudfrontDomainName string
)

func HandleRequest(ctx context.Context, event events.S3Event) error {
	return warmup.Warmup(cloudfrontDomainName, event)
}

func main() {
	cloudfrontDomainName = os.Getenv("DOMAIN_NAME")
	if cloudfrontDomainName == "" {
		log.Fatalf("DOMAIN_NAME not set")
	}

	lambda.Start(HandleRequest)
}
