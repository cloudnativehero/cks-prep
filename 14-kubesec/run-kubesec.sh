#!/bin/sh
docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < pod.yaml
