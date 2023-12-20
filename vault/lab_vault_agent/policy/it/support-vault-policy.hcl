# When using namespaces from the root namespace, need to append the namespace to the policy when installing in the root namespace.

path "k8s-secret/data/it/support/*" {
    capabilities = ["read", "list"]
}

path "k8s-secret/metadata/it/support/*" {
    capabilities = ["read", "list"]
}