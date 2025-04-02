# Infrastructure Deployment Guide

This document outlines the steps to deploy and manage the infrastructure for the network and web server components.  We will be using Terraform to provision and manage the infrastructure, and SSH for accessing the deployed instances apart from that we will be using ALB to access apace webserver which are deployed in the non production env.

## Prerequisites

*   Terraform installed
*   AWS CLI configured with appropriate credentials
*   SSH client

## Bucket Configuration

A shared S3 bucket named `env-aftabsbigbukcet` will be used for storing Terraform state. Ensure this bucket exists before proceeding.  If not, create it.

## Network Deployment (`network` folder)

1.  **Navigate to the Network Directory:**

    ```bash
    cd network
    ```

2.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

3.  **Plan the Deployment:**

    ```bash
    terraform plan
    ```

4.  **Apply the Deployment:**

    ```bash
    terraform apply
    ```

    This will create the necessary network infrastructure components.

## Web Server Deployment (`webserver` folder)

1.  **Navigate to the Web Server Directory:**

    ```bash
    cd ../webserver
    ```

2.  **Generate SSH Key Pair:**

    ```bash
    ssh-keygen -t rsa -f ./my_key
    ```
    This command generates an RSA key pair without a passphrase and saves it to `my_key` (private key) and `my_key.pub` (public key) in the current directory.

3.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

4.  **Plan the Deployment:**

    ```bash
    terraform plan
    ```

5.  **Apply the Deployment:**

    ```bash
    terraform apply
    ```

    This will create the web server instances, load balancer, and other related resources. Note down the Bastion IP address after successful deployment. Also, Note down the ALB address after successful deployment. This is where your Apache server will be accessible.

6.  **Copy the key in the bastion using command:**
    
    ```bash
    scp -i ./my_key ./my_key ec2-user@<bastionip>:/home/ec2-user/
    ```

7.  **You can SSH into the bastion host and use the same command inside bastion to access any VM**

    ```bash
    ssh ec2-user@<bastionip> -i ./my_key
    ```

7.  **Use the below command in both network and webserver folder to destory all the resources**

    ```bash
    terraform destroy
    ```

    ![image](https://github.com/user-attachments/assets/9352c00e-945a-4141-bbe5-1334957b1f87)











