
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