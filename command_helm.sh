#!/bin/bash

# Installation


# First Creat

helm create webapp1
# tree webapp1
# .
# ├── charts
# ├── Chart.yaml
# ├── templates
# │   ├── configmap.yaml
# │   ├── deployment.yaml
# │   ├── NOTES.txt
# │   └── service.yaml
# ├── values-default.yaml
# ├── values-dev.yaml
# ├── values.yaml
# └── webapp1-0.1.1.tgz


# Install
helm install mywebapp-release ['helm_dir']/   --values webapp1/values.yaml
heml install mywebapp-release webapp1/  

# Install with custom values
helm install lib --set database.volume=10

# Upgrade
helm upgrade mywebapp-release webapp1/ --values webapp1/values.yaml

# For 2 values file
helm install mywebapp-release-dev webapp1/ \
--values webapp1/values.yaml \
-f webapp1/values-dev.yaml -n dev

helm upgrade mywebapp-release webapp1/ \
--values webapp1/values.yaml \
-f webapp1/values-default.yaml

# Delete installation
helm delete mywebapp-release
helm uninstall mywebapp-release

# List out helm release versions
helm ls
hekm ls --all-namespaces
# NAME                    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
# mywebapp-release        default         15              2024-04-29 11:57:06.281144383 +0700 +07 deployed        webapp1-0.1.1   1.17.0     
# mywebapp-release-dev    default         1               2024-04-29 11:38:37.024721937 +0700 +07 deployed        webapp1-0.1.1   1.17.0 



# D

# Export template from Helm chart
helm template . --values ./values.yaml -f ./values-dev.yaml 
# Source: webapp1/templates/configmap.yaml
# kind: ConfigMap 
# apiVersion: v1 
# metadata:
#   name: configmapv1.0
#   namespace: dev
# ....

----------------------------------------------------------------

### Working with Repo ###

# Package and upload helm chart to repository
helm package webapp1/ -d charts
# This create package like webapp1-0.1.1.tgz
# [chart_name]-[chart_version].tgz
# tree charts/
# charts/
# └── webapp1-0.1.1.tgz

helm repo index charts  # create index file for charts
# tree charts/
# charts/
# ├── index.yaml
# └── webapp1-0.1.1.tgz
#
# cat charts/index.yaml 
# apiVersion: v1
# entries:
#   webapp1:
#   - apiVersion: v2
#     appVersion: 1.17.0
#     .................

helm repo add chart_name https://artifacthub.io/repo_dir

helm update repo 

helm install release_name repo/chart

----
servicename=$(kubectl get svc -l "app=mywebapp" -o jsonpath="{.items[0].metadata.name}" )
kubectl port-forward  service/mywebapp 8082:80 --namespace=default
