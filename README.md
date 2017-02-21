# Deploy distributed Minio locally with minikube

Minikube runs a single-node Kubernetes cluster inside a VM on your computer. This makes it easy to deploy distributed Minio server on 
Kubernetes running locally on your computer. 

## Prerequisites

[Minikube](https://github.com/kubernetes/minikube/blob/master/README.md#installation) and [kubectl](https://kubernetes.io/docs/user-guide/prereqs/)
installed on your system.

## Steps

* Download [minio_distributed.sh](minio_dist.sh) and [statefulset.yaml](statefulset.yaml) files on your computer. 
* For Linux/macOS execute the minio_distributed.sh script in command prompt. 

## Behind the scenes

Minikube currently does not support dynamic provisioning, so we manually create PersistentVolumes(PV) and PersistentVolumeClaims(PVC) to be 
used by the distributed Minio setup. Once the PVs and PVCs are created, we call the statefulset.yaml configuration file to create the distributed
Minio setup. 

