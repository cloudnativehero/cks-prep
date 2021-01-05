#!/bin/sh

openssl genrsa -out jane.key 2048
openssl req -new -key jane.key -out jane.csr -config jane.conf
CSR_VAL=`cat jane.csr | base64 -w 0`
sed -e 's,CSR_VAL,'$CSR_VAL',g' < template.yaml > jane-csr.yaml

