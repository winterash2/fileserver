#!/bin/bash -l

echo "Configuring Vault for the IT secrets"
echo ""
vault policy write it-support-read vault/lab_vault_agent/policy/it/support-vault-policy.hcl

vault write auth/kubernetes/role/it-support \
    bound_service_account_names=support \
    bound_service_account_namespaces=it \
    policies=it-support-read \
    ttl=24h
echo "Done"
echo ""
echo "Enabling KV secret engine"
vault secrets enable -path k8s-secret kv-v2

vault kv put k8s-secret/it/support/config \
    ttl='30s' \
    username='support' \
    password='support-suP3rsec(et!'
echo "Done"
echo ""
echo "Creating vault-agent-it-support-pod.yml"
cat > vault/lab_vault_agent/k8s/deployment/vault-agent-it-support-pod.yml << EOL
---
apiVersion: v1
kind: Pod
metadata:
  name: vault-agent-it-support
spec:
  serviceAccountName: support
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
          - key: it-support-agent-config.hcl
            path: vault-agent-config.hcl
    - name: ca-pemstore
      configMap:
        name: ca-pemstore
    - name: shared-data
      emptyDir: {}

  containers:
    # Generic container run in the context of vault agent
    - name: vault-agent
      image: gcr.io/is-enablement/vault-agent:1.9.4

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

      # This assumes Vault running on local host and K8s running in Minikube using VirtualBox
      env:
        - name: VAULT_ADDR
          value: ${VAULT_ADDR}
        - name: VAULT_K8S_AUTH_MOUNT
          value: kubernetes
        - name: VAULT_K8S_AUTH_ROLE
          value: it-support
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
EOL

echo "Done"