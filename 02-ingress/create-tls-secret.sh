#!/bin/sh

kubectl create secret tls secure-ingress --key=key.pem --cert=cert.pem
