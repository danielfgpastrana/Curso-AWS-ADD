# Librerías y recursos útiles

- [CLI Command CloudFormation](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/): Documentación oficial de los comandos CLI para CloudFormation.

- [AWS CLI Builder](https://awsclibuilder.com/home/services/cloudformation): Generador visual de comandos para AWS CLI, útil para crear y modificar stacks de CloudFormation.
- [Instalar un LAMP en Amazon Linux](https://docs.aws.amazon.com/linux/al2023/ug/ec2-lamp-amazon-linux-2023.html): Guía oficial para instalar un stack LAMP en Amazon Linux 2023.

# Despliegue y gestión del stack en AWS CloudFormation

## Uso del script parametrizable

El script `create_stack.sh` permite crear o actualizar el stack de infraestructura de forma flexible y reutilizable, usando variables genéricas para todos los parámetros definidos en `infra.yml`.

### Crear un stack nuevo

```bash
./create_stack.sh
```

### Actualizar un stack existente (sin eliminar recursos)

```bash
./create_stack.sh update
```

### Personalizar parámetros (por variables de entorno)

Puedes sobreescribir cualquier parámetro exportando variables de entorno antes de ejecutar el script:

```bash
export STACK_NAME="mi-stack"
export INSTANCE_TYPE="t3.medium"
export INSTANCE_NAME="servidor-pruebas"
export VPC_ID="vpc-xxxx"
export SUBNET_ID="subnet-xxxx"
export SECURITY_GROUP_ID="sg-xxxx"
export LATEST_AMI_ID="ami-xxxx"
export LAUNCH_TEMPLATE_NAME="lt-mi-template"
export AUTOSCALING_GROUP_NAME="asg-mi-grupo"
export SUBNET1="subnet-xxxx"
export SUBNET2="subnet-yyyy"
export TAG_NAME="Web Server - Pruebas"
./create_stack.sh [create|update]
```

Si no defines un parámetro, se usará el valor por defecto del script.

### Personalizar parámetros (por argumentos directos)

Puedes modificar el script para aceptar argumentos directos si lo prefieres, pero la forma recomendada es por variables de entorno.

### Parámetros soportados

Todos los parámetros definidos en la sección `Parameters` de `infra.yml` pueden ser sobreescritos.

### Ejemplo de actualización de tipo de instancia

```bash
export INSTANCE_TYPE="t3.medium"
./create_stack.sh update
```

### Ejemplo de cambio de nombre de instancia

```bash
export INSTANCE_NAME="nuevo-nombre"
./create_stack.sh update
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