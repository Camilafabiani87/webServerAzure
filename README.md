# Azure Infrastructure Operations Project: Deploying a Scalable IaaS Web Server in Azure

## Introduction
In this project, you will develop a Packer template and a Terraform template with the purpose of deploying a scalable and adaptable web server in Microsoft Azure. The primary goal of this project is to simplify the process of creating custom virtual machines in Azure using Packer and Terraform tools. This enables users to generate custom images with Packer and subsequently deploy virtual machine instances using Terraform.

## Getting Started
1. **Clone this repository**: Begin by cloning this repository to your local machine using the following command:

git clone https://github.com/udacity/nd082-Azure-Cloud-DevOps-Starter-Code.git


2. **Install Dependencies**: Install and set up the necessary dependencies for your development environment. These dependencies are detailed in the "Dependencies" section below.

3. **Create Infrastructure as Code**: Once you have cloned the repository and have all the necessary tools installed, you can start creating your infrastructure as code.

Infrastructure as code involves defining and managing your Azure infrastructure using configuration files instead of manual configurations. In this project, we use Packer to create custom images and Terraform to deploy virtual machine instances based on those images.

4. **Follow the Instructions**: Follow the instructions in the "Instructions" section for detailed information on how to create and manage your infrastructure in Azure using these tools.

## Dependencies
Before you start, make sure you have the following components installed in your development environment:

- [Create an Azure Account](https://portal.azure.com)
- [Install the Azure Command Line Interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Install Packer](https://www.packer.io/downloads)
- [Install Terraform](https://www.terraform.io/downloads.html)

## Instructions
### Main Steps
The project consists of the following main steps:

#### 1. Deploy a Policy
Before getting started, create a policy that ensures all indexed resources are tagged for better organization and tracking. This policy will also help in logging when issues occur.

- **Create and Apply a Tagging Policy**: Create a policy that ensures all indexed resources in your subscription have tags and deny deployment if they do not. Write a policy definition to deny the creation of resources that do not have tags. Apply the policy definition to the subscription with the name "tagging-policy". Use the following Azure commands:
  - `az policy definition create --name tagging-policy --rules policy.json` (create a policy definition in Azure Policy)
  - `az policy assignment create --policy tagging-policy` (used to create a policy assignment in Azure Policy)
  - `az policy assignment list` (to view the list of policies)

#### 2. Packer Template
To support application deployment, you'll need to create a custom image that different organizations can use. Follow these steps:

- **Create a Packer Template**:
  a. Navigate to the Packer directory in your project.
  b. Modify the `server.json` file according to your needs. Ensure you configure Azure credentials and other necessary parameters.
  c. Run Packer to create the custom image.
  d. Note the name of the generated image. Remember to use Ubuntu 18.04-LTS SKU as your base image.

#### 3. Deploy Virtual Machines with Terraform
a. Navigate to the Terraform directory in your project.
b. Modify the `vars.tf` file according to your needs. Ensure you define the correct values for the VM image and other Azure resources. Allow for customer configuration of the number of virtual machines and deployment at a minimum.
Open the `vars.tf` File:
 Start by opening the `vars.tf` file in a text editor or your development environment. This file is where you'll define the variables used in your Terraform configuration.
Define necessary variables: 
Identify the variables required to configure and deploy your infrastructure in Azure. These variables can include items such as the name of a custom Packer image, the number of virtual machines to deploy, locations, VM sizes, and more.
-variable "variable_name": This defines a variable named "variable_name."
-description: An optional description that can help collaborators understand the variable's purpose.
-type: Specifies the variable type, such as "string," "number," "bool," etc.
-default: You can provide a default value if desired, but it's optional.

After defining these variables, you can use them in your Terraform configuration to make your infrastructure setup more flexible and customizable.

c. Modify the `main.tf` file:
   - Create a resource group.
   - Create a virtual network and a subnet on that virtual network.
   - Create a network security group.
   - Create a public IP.
   - Create a load balancer.
   - Create a virtual machine.
d. Initialize Terraform to download the required providers and modules.
e. Preview the changes that will be made to your infrastructure.
f. Apply the changes to create virtual machines and other resources in Azure.
g. Confirm the changes by typing "yes" when prompted.

#### 4. Deploying Your Infrastructure
Make sure to do the following:
- Run `packer build server.json` (This command instructs Packer to use the "server.json" file as the build configuration and initiates the image creation process based on the configuration you defined in that file).

- For Terraform:
  - Run `terraform init` (To initialize).
  - Run `terraform plan` (to see the resources that will be created).
  - Run `terraform plan -out solution.plan`.
  - Run `terraform apply` (to apply your plan and deploy your infrastructure).
  - Run `terraform show` (to view your new infrastructure).
  - Run `terraform destroy` (to tear down your infrastructure).


## Output

Upon successful implementation, this project will deliver a robust and scalable web server infrastructure in Microsoft Azure, driven by efficient automation and infrastructure as code (IaC) practices. Here's a detailed breakdown of the outcomes and benefits you can expect:

### 1. Scalable Web Server Infrastructure
   - **Multiple Virtual Machines**: Your Azure infrastructure will include multiple virtual machines, all created from the custom image generated using Packer. These VM instances can be easily scaled up or down to meet your application's demands, ensuring optimal performance and resource utilization.

### 2. Customization and Reusability
   - **Custom Packer Image**: The Packer template you've created allows you to build a custom virtual machine image tailored to your specific needs. This image is reusable, making it effortless to deploy consistent environments in the future.

### 3. Efficient Azure Resource Management
   - **Resource Group**: Terraform will create a resource group to organize and manage all the resources related to your infrastructure, ensuring efficient resource management and easy cleanup if necessary.

   - **Virtual Network and Subnet**: A virtual network with a dedicated subnet will be set up to isolate your infrastructure and control network traffic effectively.

   - **Network Security**: Network security groups will enhance the security of your VM instances, allowing you to define inbound and outbound traffic rules.

   - **Public IP and Load Balancer**: The infrastructure will include a public IP and a load balancer, providing high availability and distributing incoming traffic across multiple VM instances for load balancing.

### 4. Azure Policy Enforcement
   - **Tagging Policy**: By creating and applying the tagging policy, all indexed resources in your subscription will have required tags. This not only ensures better organization and tracking but also enforces consistent tagging practices across your Azure resources.

### 5. Streamlined Operations and Maintenance
   - **Automation**: The use of Packer and Terraform streamlines the deployment process. You can easily rebuild your infrastructure or make updates without manual intervention, reducing operational overhead.

### 6. Enhanced Infrastructure as Code (IaC)
   - **Reproducibility**: Your entire infrastructure is defined as code, making it reproducible. You can create identical environments in other Azure regions or subscriptions by applying the same templates.

### 7. Detailed Documentation
   - **README**: This README provides comprehensive guidance on setting up and managing your infrastructure. It serves as a valuable reference for maintaining your Azure environment effectively.

By following the instructions and best practices outlined in this project, you'll have a scalable, customizable, and well-managed web server infrastructure in Azure, ready to support your applications and services with ease.

