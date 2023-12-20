#!/bin/bash -l
echo "Creating deployment directory for IT"
mkdir -p /root/vault/lab_k8s/deployment/it
echo "Done"
echo "Creating deployment directory for Finance"
mkdir -p /root/vault/lab_k8s/deployment/finance
echo "Setting namespace to IT"
export NAMESPACE=it
echo "Creating pod yaml for operations"
export APP=operations
vault/lab_k8s/scripts/template-k8s-pod.yml.sh
echo "Done"
echo "Creating pod yaml for support"
export APP=support
vault/lab_k8s/scripts/template-k8s-pod.yml.sh
echo "Done"
echo "Setting namespace to finance"
export NAMESPACE=finance
echo "Creating pod yaml for ar-app"
export APP=ar-app
vault/lab_k8s/scripts/template-k8s-pod.yml.sh
echo "Done"
echo "Creating pod yaml for ap-app"
export APP=ap-app
vault/lab_k8s/scripts/template-k8s-pod.yml.sh
echo "Done"