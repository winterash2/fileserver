#!/bin/bash -l

echo "Setting env vars"
export VAULT_ADDR="http://vault-rootca:8200"
export VAULT_TOKEN="root"

echo "Getting CSR Signed"
vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
      format=pem_bundle ttl="43800h" \
      | jq -r '.data.certificate' > intermediate.cert.pem

echo "CSR is signed. Outputing signed PEM"
openssl x509 -in intermediate.cert.pem -noout -text




