#!/bin/bash
# Script para crear o actualizar el stack de CloudFormation de forma parametrizada

STACK_NAME="danieldf-stack"
TEMPLATE_FILE="infra.yml"
REGION="us-east-1"
PROFILE="default"


# Parámetros genéricos (modifica según tu entorno)
VPC_ID="vpc-086fe118b4ed5c6e4"
SUBNET_ID="subnet-0f86fb485374f9f0a"
INSTANCE_TYPE="t3.micro"
INSTANCE_NAME="danieldf-instance"
SECURITY_GROUP_ID="sg-04f4c192bcfcf3f2b"
LAUNCH_TEMPLATE_NAME="lt-danieldf"
AUTOSCALING_GROUP_NAME="asg-danieldf"
SUBNET1="subnet-0f86fb485374f9f0a"
SUBNET2="subnet-0323a098b70caa778"
TAG_NAME="Web Server - danieldf"
LATEST_AMI_ID="ami-039a65ec6bd28e541"
MIN_SIZE="0"
DESIRED_CAPACITY="0"
MAX_SIZE="4"

# Construir la cadena de parámetros para CloudFormation
PARAMETERS=(
  ParameterKey=VpcId,ParameterValue=$VPC_ID
  ParameterKey=SubnetId,ParameterValue=$SUBNET_ID
  ParameterKey=InstanceType,ParameterValue=$INSTANCE_TYPE
  ParameterKey=InstanceName,ParameterValue=$INSTANCE_NAME
  ParameterKey=SecurityGroupId,ParameterValue=$SECURITY_GROUP_ID
  ParameterKey=LaunchTemplateName,ParameterValue=$LAUNCH_TEMPLATE_NAME
  ParameterKey=AutoScalingGroupName,ParameterValue=$AUTOSCALING_GROUP_NAME
  ParameterKey=Subnet1,ParameterValue=$SUBNET1
  ParameterKey=Subnet2,ParameterValue=$SUBNET2
  ParameterKey=TagName,ParameterValue="$TAG_NAME"
  ParameterKey=LatestAmiId,ParameterValue=$LATEST_AMI_ID
  ParameterKey=MinSize,ParameterValue=$MIN_SIZE
  ParameterKey=MaxSize,ParameterValue=$MAX_SIZE
  ParameterKey=DesiredCapacity,ParameterValue=$DESIRED_CAPACITY
)

echo "Verificando si el stack $STACK_NAME existe..."
aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --profile $PROFILE &> /dev/null
if [ $? -eq 0 ]; then
  echo "Actualizando el stack $STACK_NAME..."
  aws cloudformation update-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --capabilities CAPABILITY_IAM \
    --region $REGION \
    --profile $PROFILE \
    --parameters "${PARAMETERS[@]}"
else
  echo "Creando el stack $STACK_NAME..."
  aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --capabilities CAPABILITY_IAM \
    --region $REGION \
    --profile $PROFILE \
    --parameters "${PARAMETERS[@]}"
fi