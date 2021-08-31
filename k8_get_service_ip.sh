#!/bin/bash
name=$1
kubectl get services | grep $name | awk '{print $3}'
