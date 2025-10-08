#!/bin/bash
# Script para eliminar el stack de AWS CloudFormation

STACK_NAME="danieldf-stack"

aws cloudformation delete-stack \
  --stack-name "$STACK_NAME" \
  --region us-east-1 \
  --profile default \
  --output json

echo "Stack de AWS CloudFormation en proceso de eliminación: $STACK_NAME"