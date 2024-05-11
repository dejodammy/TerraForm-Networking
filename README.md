Application Overview
This Terraform configuration defines infrastructure resources for a development environment on AWS. The setup includes networking components, EC2 instances, security groups, an internet gateway, RDS database instances, and associated configurations. Below is a breakdown of the resources and their functionalities.

Infrastructure Components
VPC (Virtual Private Cloud)
Creates a VPC with the CIDR block 10.123.0.0/16.
Enables DNS support and hostnames.
Tagged as "dev".
Subnets
Defines public subnets (mtc_public_subnet_a and mtc_public_subnet_b) in two availability zones (us-east-1a and us-east-1b) with CIDR blocks 10.123.1.0/24 and 10.123.4.0/24 respectively.
Associates these public subnets with the route table for internet access.
Internet Gateway
Attaches an internet gateway to the VPC for internet connectivity.
Route Table
Creates a route table (mtc_public_rt) associated with the public subnets.
Adds a default route (0.0.0.0/0) via the internet gateway.
Route Table Association
Associates the public subnets with the route table to enable internet access.
Security Groups
Defines two security groups (mtc_sg1 and mtc_sg2).
mtc_sg1 allows all inbound and outbound traffic (not recommended for production).
mtc_sg2 permits inbound MySQL (port 3306) traffic only from instances associated with mtc_sg1.
Key Pair
Sets up an AWS key pair (mtc_auth) used for SSH access to EC2 instances.
EC2 Instances
Launches two EC2 instances (dev_node_a and dev_node_b) in the public subnets (mtc_public_subnet_a and mtc_public_subnet_b).
Associates security group mtc_sg1 with these instances.
Configures instances with user data and SSH access via the specified key pair.
RDS Database Instances
Creates two RDS instances (mtc_rds_a and mtc_rds_b) using MySQL version 5.7 (db.t3.micro instance class).
Configures security group mtc_sg2 for database access.
Specifies username/password and skips the final snapshot on termination.
Database Subnet Group
Defines a subnet group (mtc_subnet_group2) for RDS instances, including private subnets (mtc_private_subnet and mtc_private_subnet2).
Readme
Purpose
This Terraform script provisions infrastructure for a development environment on AWS, including networking, compute, and database resources.

Usage
Pre-requisites
AWS CLI configured with necessary credentials.
Terraform installed locally.
Instructions
Clone this repository.
Navigate to the directory containing the Terraform configuration.
Run terraform init to initialize the directory.
Run terraform apply to create the infrastructure as defined in this script.
Notes
Ensure proper AWS IAM permissions for the user/role running Terraform.
Review and customize security group rules (mtc_sg1 and mtc_sg2) for production usage.
Regularly update resources (e.g., AMI IDs, instance types) based on project requirements and AWS updates.
This Terraform setup automates the creation of a basic development environment on AWS with networking isolation, EC2 instances, and managed MySQL databases. Adjustments can be made to suit specific project needs and security best practices.
