#!/bin/bash -l

echo "Enabling KV secret engine"
vault secrets enable -path k8s-secret kv-v2

echo "Pushing secrets to vault"
vault kv put k8s-secret/it/operations/config \
    ttl='30s' \
    username='operations' \
    password='operations-suP3rsec(et!'

vault kv put k8s-secret/it/support/config \
    ttl='30s' \
    username='support' \
    password='support-suP3rsec(et!'

vault kv put k8s-secret/finance/ar-app/config \
    ttl='30s' \
    username='ar-app' \
    password='ar-app-suP3rsec(et!'

vault kv put k8s-secret/finance/ap-app/config \
    ttl='30s' \
    username='ap-app' \
    password='ap-app-suP3rsec(et!'