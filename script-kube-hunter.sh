#! /bin/bash


kubectl create -f https://raw.githubusercontent.com/aquasecurity/kube-hunter/master/job.yaml

oc get pods

read -p "Please enter the kube-hunter pod name: " selectedPod

kubectl logs $selectedPod
