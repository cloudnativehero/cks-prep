#!/bin/sh

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/baremetal/deploy.yaml
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
