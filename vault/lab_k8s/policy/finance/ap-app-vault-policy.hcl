path "k8s-secret/data/finance/ap-app/*" {
    capabilities = ["read", "list"]
}

path "k8s-secret/metadata/finance/ap-app/*" {
    capabilities = ["read", "list"]
}