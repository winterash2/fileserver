#!/bin/bash

cat > vault/lab_k8s/deployment/${NAMESPACE}/${APP}.yaml << EOL
---
apiVersion: v1
kind: Pod
metadata:
  name: vault-agent-${NAMESPACE}-${APP}
spec:
  serviceAccountName: ${APP}
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
          - key: ${NAMESPACE}-${APP}-agent-config.hcl
            path: vault-agent-config.hcl
    - name: ca-pemstore
      configMap:
        name: ca-pemstore
    - name: shared-data
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

      # This assumes Vault running on local host and K8s running in Minikube using VirtualBox
      env:
        - name: VAULT_ADDR
          value: ${VAULT_ADDR}
        - name: VAULT_K8S_AUTH_MOUNT
          value: kubernetes
        - name: VAULT_K8S_AUTH_ROLE
          value: ${NAMESPACE}-${APP}
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
