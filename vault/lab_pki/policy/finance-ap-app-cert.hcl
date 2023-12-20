# This allows the role to create a certificate
path "pki/issue/example-dot-com" {
    capabilities = ["create", "update"]
}

# This allows the role to read a CA chain if needed
path "pki/ca_chain" {
    capabilities = ["read"]
}

# These paths allow for the vault agent to auto renew the vault token
path "auth/token/renew" {
    capabilities = ["update"]
}

path "auth/token/renew-self" {
    capabilities = ["update"]
}