#!/usr/bin/env bash

# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Run the Minio StatefulSet example on a minikube instance.
#
# For a fresh start, run the following first:
#   minikube delete
#   minikube start
#
# To upgrade minikube & kubectl on OSX, the following should suffice:
#   brew reinstall kubernetes-cli --devel
#   url -Lo minikube \
#     https://storage.googleapis.com/minikube/releases/v0.4.0/minikube-darwin-amd64 && \
#   chmod +x minikube && sudo mv minikube /usr/local/bin/

set -exuo pipefail

# Clean up anything from a prior run:
kubectl delete statefulsets,persistentvolumes,persistentvolumeclaims,services,poddisruptionbudget -l app=minio

# Make persistent volumes and (correctly named) claims. We must create the
# claims here manually even though that sounds counter-intuitive. For details
# see https://github.com/kubernetes/contrib/pull/1295#issuecomment-230180894.
for i in $(seq 0 3); do
  cat <<EOF | kubectl create -f -
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv${i}
  labels:
    type: local
    app: minio
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/minio/data-store/${i}"
EOF

  cat <<EOF | kubectl create -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: data-minio-${i}
  labels:
    app: minio
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
EOF
done;

kubectl create -f statefulset.yaml
