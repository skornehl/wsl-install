#!/bin/bash

kubectl --namespace=$1 get secret $2 -o jsonpath="{.data.$3}" | base64 --decode