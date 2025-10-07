# Librerías y recursos útiles

- [CLI Command CloudFormation](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/): Documentación oficial de los comandos CLI para CloudFormation.

- [AWS CLI Builder](https://awsclibuilder.com/home/services/cloudformation): Generador visual de comandos para AWS CLI, útil para crear y modificar stacks de CloudFormation.
- [Instalar un LAMP en Amazon Linux](https://docs.aws.amazon.com/linux/al2023/ug/ec2-lamp-amazon-linux-2023.html): Guía oficial para instalar un stack LAMP en Amazon Linux 2023.
# Despliegue y gestión del stack en AWS CloudFormation

## Crear el stack

```bash
aws cloudformation create-stack \
	--stack-name danielfgpastrana-654654327431 \
	--template-body file://infra.yml \
	--capabilities CAPABILITY_IAM \
	--region us-east-1 \
	--profile default \
	--output json \
	--parameters \
		ParameterKey=VpcId,ParameterValue=vpc-086fe118b4ed5c6e4 \
		ParameterKey=SubnetId,ParameterValue=subnet-0f86fb485374f9f0a \
		ParameterKey=InstanceType,ParameterValue=t3.micro \
		ParameterKey=InstanceName,ParameterValue=danielfgpastrana \
		ParameterKey=SecurityGroupId,ParameterValue=sg-04f4c192bcfcf3f2b
```

## Cambiar el nombre de la instancia

```bash
aws cloudformation update-stack \
	--stack-name danielfgpastrana-654654327431 \
	--template-body file://infra.yml \
	--capabilities CAPABILITY_IAM \
	--region us-east-1 \
	--profile default \
	--output json \
	--parameters \
		ParameterKey=SubnetId,UsePreviousValue=true \
		ParameterKey=SecurityGroupId,UsePreviousValue=true \
		ParameterKey=VpcId,UsePreviousValue=true \
		ParameterKey=InstanceType,UsePreviousValue=true \
		ParameterKey=InstanceName,ParameterValue=danielfgpastrana
```

## Cambiar el tipo de instancia (por ejemplo, de t3.micro a t3.medium)

```bash
aws cloudformation update-stack \
	--stack-name danielfgpastrana-654654327431 \
	--template-body file://infra.yml \
	--region us-east-1 \
	--output json \
	--capabilities CAPABILITY_IAM \
	--parameters \
		ParameterKey=SubnetId,UsePreviousValue=true \
		ParameterKey=SecurityGroupId,UsePreviousValue=true \
		ParameterKey=VpcId,UsePreviousValue=true \
		ParameterKey=InstanceName,UsePreviousValue=true \
		ParameterKey=InstanceType,ParameterValue=t3.medium
```

# Requerimientos de Diseño para la Infraestructura AWS

1. **Plantilla CloudFormation**
	- El archivo de infraestructura debe llamarse `infra.yml`.
	- La plantilla debe ser clara, modular y seguir buenas prácticas de nomenclatura y organización de recursos.

2. **Red (VPC)**
	- Utilizar la VPC por defecto de la cuenta, con el ID: `vpc-086fe118b4ed5c6e4`.
	- Todos los recursos deben estar asociados explícitamente a esta VPC.

3. **Instancia EC2**
	- Crear una instancia EC2 de tipo `t3.micro` (o el tipo T3 más adecuado según necesidades).
	- Etiquetar la instancia con el nombre `nombre`.
	- Usar la imagen más reciente de Amazon Linux 2023, seleccionada dinámicamente según la región.
	- La instancia debe estar en una subred pública de la VPC por defecto.

4. **Seguridad**
	- No utilizar pares de claves SSH para acceso.
	- Crear un rol IAM específico para la instancia, con permisos mínimos necesarios (principio de menor privilegio).
	- Asociar el rol IAM creado a la instancia EC2.
	- Asociar el grupo de seguridad por defecto de la VPC a la instancia EC2.
	- Limitar el acceso entrante solo a los puertos y direcciones IP estrictamente necesarios.

5. **Buenas Prácticas**
	- Definir salidas (`Outputs`) relevantes en la plantilla, como el ID de la instancia, IP pública, etc.
	- Documentar cada recurso con comentarios en la plantilla.
	- Validar la plantilla con herramientas como `cfn-lint` antes de su despliegue.