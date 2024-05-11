<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Infrastructure README</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background-color: #f8f9fa;
        }

        .container {
            max-width: 800px;
            margin: auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        h1,
        h2,
        h3 {
            color: #333;
        }

        h2 {
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        code {
            background-color: #f8f9fa;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: Consolas, monospace;
        }

        pre {
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            overflow-x: auto;
        }

        ul {
            list-style-type: disc;
            padding-left: 20px;
        }

        p {
            margin-bottom: 15px;
        }
    </style>
</head>

<body>
    <div class="container">
        <h1>Infrastructure Overview</h1>

        <p>This document describes the infrastructure setup for a development environment on AWS using Terraform.</p>

        <h2>Components</h2>

        <ol>
            <li><strong>VPC (Virtual Private Cloud)</strong>
                <ul>
                    <li>CIDR Block: <code>10.123.0.0/16</code></li>
                    <li>DNS Hostnames: Enabled</li>
                    <li>DNS Support: Enabled</li>
                    <li>Tags: <code>Name=dev</code></li>
                </ul>
            </li>

            <li><strong>Subnets</strong>
                <ul>
                    <li>Public Subnet A:
                        <ul>
                            <li>CIDR Block: <code>10.123.1.0/24</code></li>
                            <li>Map Public IP: Enabled</li>
                            <li>Availability Zone: <code>us-east-1a</code></li>
                            <li>Tags: <code>Name=dev-public</code></li>
                        </ul>
                    </li>
                    <li>Public Subnet B:
                        <ul>
                            <li>CIDR Block: <code>10.123.4.0/24</code></li>
                            <li>Map Public IP: Enabled</li>
                            <li>Availability Zone: <code>us-east-1b</code></li>
                            <li>Tags: <code>Name=dev-public</code></li>
                        </ul>
                    </li>
                </ul>
            </li>

            <!-- Other components can be added similarly -->

        </ol>

        <h2>Usage</h2>

        <p>To deploy this infrastructure:</p>

        <pre><code>git clone https://github.com/your/repository.git
cd repository-directory
terraform init
terraform apply</code></pre>

        <p>Make sure you have the AWS CLI configured with appropriate credentials and Terraform installed.</p>

        <h2>Notes</h2>

        <ul>
            <li>Update configuration parameters like AMI IDs, instance types, and security group rules as needed.</li>
            <li>Review IAM permissions for the Terraform user to ensure necessary access.</li>
            <li>Always follow security best practices for production environments.</li>
        </ul>
    </div>
</body>

</html>
