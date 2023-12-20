#!/bin/bash -l

echo "Configuring Vault for the IT secrets"
echo ""
vault policy write finance-ap-app-read vault/lab_pki/policy/ap-app-vault-policy.hcl

vault write auth/kubernetes/role/finance-ap-app \
    bound_service_account_names=ap-app \
    bound_service_account_namespaces=finance \
    policies=finance-ap-app-read \
    ttl=24h
echo "Done"
echo ""
echo "Enabling KV secret engine"
vault secrets enable -path k8s-secret kv-v2

vault kv put k8s-secret/finance/ap-app/config \
    ttl='30s' \
    username='ap-app' \
    password='ap-app-suP3rsec(et!'
echo "Done"
echo ""
echo "Creating pki-finance-ap-app-pod.yml"
mkdir -p vault/lab_pki/deployment
cat > vault/lab_pki/deployment/pki-finance-ap-app-pod.yml << EOL
---
apiVersion: v1
kind: Pod
metadata:
  name: pki-finance-ap-app
spec:
  serviceAccountName: ap-app
  restartPolicy: Never
  hostAliases:
  - ip: $VAULT_IP
    hostnames:
    - "vault-server"
  volumes:
    - name: vault-token
      emptyDir:
        medium: Memory
    - name: config
      configMap:
        name: vault-agent-configs
        items:
          - key: finance-ap-app-agent-config.hcl
            path: vault-agent-config.hcl
    - name: ca-pemstore
      configMap:
        name: ca-pemstore
    - name: shared-data
      emptyDir: {}
    - name: shared-certs
      emptyDir: {}

  containers:
    # Generic container run in the context of vault agent
    - name: vault-agent
      image: gcr.io/is-enablement/vault-agent:latest

      volumeMounts:
        - name: vault-token
          mountPath: /home/vault
        - name: config
          mountPath: /etc/vault
        - name: shared-data
          mountPath: /etc/secrets
        - name: ca-pemstore
          mountPath: /etc/ssl/certs/vault-client.pem
          subPath: vault-client.pem
          readOnly: false
        - name: shared-certs
          mountPath: /etc/tls

      # This assumes Vault running on local host and K8s running in Minikube using VirtualBox
      env:
        - name: VAULT_ADDR
          value: ${VAULT_ADDR}
        - name: VAULT_K8S_AUTH_MOUNT
          value: kubernetes
        - name: VAULT_K8S_AUTH_ROLE
          value: finance-ap-app
        - name: LOG_LEVEL
          value: info
        - name: VAULT_CACERT
          value: /etc/ssl/certs/vault-client.pem
      # Run the Vault agent
      command: ["/bin/vault"]
      args:
        [
          "agent",
          "-config=/etc/vault/vault-agent-config.hcl",
          "-log-level=debug",
        ]

# Nginx container
    - name: nginx-container
      image: nginx

      ports:
        - containerPort: 80

      volumeMounts:
        - name: shared-data
          mountPath: /usr/share/nginx/html
        - name: shared-certs
          mountPath: /etc/tls/vault
EOL

echo "Done"