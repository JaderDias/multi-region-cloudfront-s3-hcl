package types

// https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/LocationsOfEdgeServers.html

type IPList struct {
	Global   []string `json:"CLOUDFRONT_GLOBAL_IP_LIST"`
	Regional []string `json:"CLOUDFRONT_REGIONAL_EDGE_IP_LIST"`
}
