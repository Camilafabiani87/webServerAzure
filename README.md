# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
En este proyecto, desarrollarás una plantilla de Packer y una plantilla de Terraform con el propósito de implementar un servidor web escalable y adaptable en Microsoft Azure. La finalidad principal de este proyecto es simplificar el proceso de creación de máquinas virtuales personalizadas en Azure utilizando las herramientas Packer y Terraform. Esto habilita a los usuarios para generar imágenes personalizadas con Packer y posteriormente implementar instancias de máquinas virtuales mediante Terraform.

### Getting Started
1. Clona este repositorio a tu máquina local utilizando el siguiente comando:
git clone https://github.com/udacity/nd082-Azure-Cloud-DevOps-Starter-Code.git

2. Intala y crea las dependencias necesarias para lograr tu entorno de desarrollo. Las mimas se detallan en la sección de "Dependencias"

3. Una vez que hayas clonado el repositorio y tengas todas las herramientas necesarias instaladas, puedes comenzar a crear tu infraestructura como código.

La creación de infraestructura como código implica definir y gestionar tu infraestructura de Azure utilizando archivos de configuración en lugar de configuraciones manuales. En este proyecto, utilizamos Packer para crear imágenes personalizadas y Terraform para desplegar instancias de máquinas virtuales basadas en esas imágenes.

Sigue las instrucciones en la sección "Instructions" para obtener información detallada sobre cómo crear y gestionar tu infraestructura en Azure con estas herramientas.

### Dependencies
 Antes de comenzar, asegúrate de tener instalados los siguientes componentes en tu entorno de desarrollo:
1. Crear [Azure Account](https://portal.azure.com) 
2. Instalar [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Instalar [Packer](https://www.packer.io/downloads)
4. Instalar [Terraform](https://www.terraform.io/downloads.html)

### Instructions

Pasos principales
El proyecto constará de los siguientes pasos principales:

Crear una plantilla de Packer
Crear una plantilla de Terraform
Implementación de la infraestructura

1. Crear una Imagen Personalizada con Packer
a. Navega al directorio de Packer en tu proyecto
b. Modifica el archivo server.json según tus necesidades. Asegúrate de configurar las credenciales de Azure y otros parámetros necesarios.
c. Ejecuta Packer para crear la imagen personalizada
d. Una vez que la imagen se haya creado con éxito, anota el nombre de la imagen generada.

2. Implementar Máquinas Virtuales con Terraform
a. Navega al directorio de Terraform en tu proyecto
b. Modifica el archivo vars.tf según tus necesidades. Asegúrate de definir los valores correctos para la imagen de VM y otros recursos de Azure.
c. Inicializa Terraform para descargar los proveedores y módulos necesarios
d. Previsualiza los cambios que se realizarán en tu infraestructura
e. Aplica los cambios para crear las máquinas virtuales y otros recursos en Azure
f. Confirma los cambios escribiendo "yes" cuando se te solicite.

COMANDOS 

PACKER

packer build server.json (Este comando le indica a Packer que debe usar el archivo "server.json" como configuración de construcción y comenzará el proceso de creación de la imagen según la configuración que hayas definido en ese archivo)

AZURE
az login (para loguearse)
az account show (para comprobar la sesion)
az policy definition create --name tagging-policy --rules policy.json (crear una definición de política en Azure Policy.)
az policy assignment create --policy tagging-policy (se utiliza para crear una asignación de política en Azure Policy.)
az policy assignment list (para ver la lista con las policticas)

TERRAFORM
terraform init (Para empezar)
terraform plan (para ver los recursos que se crearan)
terraform plan -out solution.plan
terraform apply (para aplicar tu plan y desplegar tu infraestructura)
terraform show (para ver tu nueva infraestructura)
terraform destroy (para derribar tu infraestructura)

### Output
Etiquetas y Organización:
Todas las máquinas virtuales están etiquetadas con el nombre del proyecto.
Se utilizan etiquetas de máquinas virtuales para organizar la arquitectura IaaS.
Seguridad de Azure:
Se administran grupos de seguridad de red según las mejores prácticas de seguridad de Azure.
Se incluye un grupo de seguridad de red en la plantilla Terraform para restringir el acceso desde fuera de la VNet.
El grupo de seguridad de red niega explícitamente el tráfico entrante desde Internet.
Se definen, aplican y validan políticas de Azure, y se muestra una captura de pantalla o resultado de az policy assignment list.
Infraestructura como Código (IaC):
La infraestructura es reutilizable y aprovecha variables de Terraform.
Se utilizan bucles de Terraform, como el uso de la característica 'count' en el recurso azurerm_linux_virtual_machine.
Se utilizan herramientas de automatización como Packer y Terraform.
Las plantillas se organizan en una carpeta con nombres específicos (main.tf, vars.tf, y una plantilla de Packer en formato .json).
Herramientas de Implementación:
Se utiliza Terraform para crear recursos de Azure.
Se utiliza Packer para crear servicios IaaS de Azure, y las máquinas virtuales hacen referencia a las imágenes generadas por la plantilla Packer.
En resumen, el proyecto se adhiere a las mejores prácticas de infraestructura como código y seguridad en Azure, aprovechando herramientas de automatización y proporcionando documentación clara para su ejecución y personalización.

