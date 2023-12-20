# When using namespaces from the root namespace, need to append the namespace to the policy when installing in the root namespace.

# Non-Namespaced policy
path "k8s-secret/data/it/operations/*" {
    capabilities = ["read", "list"]
}

path "k8s-secret/metadata/it/operations/*" {
    capabilities = ["read", "list"]
}