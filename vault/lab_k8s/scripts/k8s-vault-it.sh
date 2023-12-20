#!/bin/bash -l

echo "Configuring Vault for the IT secrets"
echo ""
vault policy write it-support-read vault/lab_k8s/policy/it/support-vault-policy.hcl

vault write auth/kubernetes/role/it-support \
    bound_service_account_names=support \
    bound_service_account_namespaces=it \
    policies=it-support-read \
    ttl=24h

vault policy write it-operations-read vault/lab_k8s/policy/it/operations-vault-policy.hcl

vault write auth/kubernetes/role/it-operations \
    bound_service_account_names=operations \
    bound_service_account_namespaces=it \
    policies=it-operations-read \
    ttl=24h
