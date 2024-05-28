```
cat << EOF > baremetal.json
{
  "iso_url": "https://releases.ubuntu.com/jammy/ubuntu-22.04.4-live-server-amd64.iso",
  "iso_checksum": "45f873de9f8cb637345d6e66a583762730bbea30277ef7b32c9c3bd6700a32b2",
  "iso_checksum_type": "sha256"
}
EOF
```
```
https://anywhere-assets.eks.amazonaws.com/releases/bundles/65/artifacts/hook/9d54933a03f2f4c06322969b06caa18702d17f66/vmlinuz-x86_64
```
```
https://anywhere-assets.eks.amazonaws.com/releases/bundles/65/artifacts/hook/9d54933a03f2f4c06322969b06caa18702d17f66/initramfs-x86_64
```
```
https://drive.google.com/file/d/1S4sIHac_VBX2hfQua3uI0UneWsN9mN3v/view?usp=sharing
https://drive.google.com/file/d/1_fMbIcd1BGqFM4gD9y0Tvzg_78WJ2E0r/view?usp=sharing
```
```
apiVersion: anywhere.eks.amazonaws.com/v1alpha1
kind: Cluster
metadata:
  name: cluster-eksa
spec:
  clusterNetwork:
    cniConfig:
      cilium: {}
    pods:
      cidrBlocks:
      - 10.10.0.0/16
    services:
      cidrBlocks:
      - 10.110.0.0/16
  controlPlaneConfiguration:
    count: 1
    endpoint:
      host: "192.168.0.10"
    machineGroupRef:
      kind: TinkerbellMachineConfig
      name: cluster-eksa-cp
  datacenterRef:
    kind: TinkerbellDatacenterConfig
    name: cluster-eksa
  kubernetesVersion: "1.28"
  managementCluster:
    name: cluster-eksa
  workerNodeGroupConfigurations:
  - count: 1
    machineGroupRef:
      kind: TinkerbellMachineConfig
      name: cluster-eksa
    name: md-0

---
apiVersion: anywhere.eks.amazonaws.com/v1alpha1
kind: TinkerbellDatacenterConfig
metadata:
  name: cluster-eksa
spec:
  tinkerbellIP: "192.168.0.201"
  osImageURL: "http://192.168.0.240:8000/ubuntu-2204-kube-1-28.gz"
  hookImagesURLPath: "http://192.168.0.240:8000/hook"

---
apiVersion: anywhere.eks.amazonaws.com/v1alpha1
kind: TinkerbellMachineConfig
metadata:
  name: cluster-eksa-cp
spec:
  hardwareSelector: 
    type: "cp"
  osFamily: ubuntu
  templateRef: {}
  users:
  - name: "ubuntu"
    sshAuthorizedKeys:
    - ""

---
apiVersion: anywhere.eks.amazonaws.com/v1alpha1
kind: TinkerbellMachineConfig
metadata:
  name: cluster-eksa
spec:
  hardwareSelector: 
    type: "worker"
  osFamily: ubuntu
  templateRef: {}
  users:
  - name: "ubuntu"
    sshAuthorizedKeys:
    - ""
```
```
hostname,bmc_ip,bmc_username,bmc_password,mac,ip_address,netmask,gateway,nameservers,labels,disk
eksa-cp01,,,,04:7C:16:04:B3:BF,192.168.0.10,255.255.255.0,192.168.0.1,8.8.8.8|8.8.4.4,type=cp,/dev/nvme0n1
eksa-wk01,,,,D8:43:AE:4D:E5:02,192.168.0.11,255.255.255.0,192.168.0.1,8.8.8.8|8.8.4.4,type=worker,/dev/nvme0n1
```
```
https://github.com/tinkerbell/hook/releases/download/latest/hook_latest-lts-x86_64.tar.gz
```
