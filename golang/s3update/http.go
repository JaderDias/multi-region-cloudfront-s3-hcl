package main

import (
	"context"
	"fmt"
	"net"
	"net/http"
	"time"
)

const timeout = time.Duration(10 * time.Second)

func GetHttpClient(ip net.IP) http.Client {
	dialer := &net.Dialer{
		Timeout:   timeout,
		KeepAlive: timeout,
	}
	return http.Client{
		Transport: &http.Transport{
			DialContext: func(ctx context.Context, network, addr string) (net.Conn, error) {
				addr = fmt.Sprintf("[%s]:443", ip)
				return dialer.DialContext(ctx, network, addr)
			},
		},
	}
}
