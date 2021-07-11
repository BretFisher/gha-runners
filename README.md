# Simple Terra

Terraform to create GitHub Action self-hosted runners in EC2 using a Launch Configuration.

There are other projects (listed below) for creating self-hosted runners that dynamically scale based on job queues and other advanced setups. My example is only meant to be a way for you to create a fixed set of runners.

## Features

- Uses Terraform. You can also use Terraform Cloud.
- Creates a EC2 Launch Configuration, which creates a Auto Scaling Group of instances.
- Uses the [myoung34/docker-github-actions-runner](https://github.com/myoung34/docker-github-actions-runner) project to run the runner.
- Updates the instances via ASG rolling refresh on Terraform reapply.
- Dynamically adds/removes runners from a org/repo using a GitHub Personal Access Token (PAT).

## Limits

- **Doesn't enable autoscaling for the ASG.** You could setup CPU/Memory in the Launch Configuration. There are also other projects that do this much more intelligently and autoscale based on runner jobs.
- **Runs one container (runner) per EC2 instance.** First, GitHub doesn't officially support runners inside a container. Their runners are inside a full VM, and only one Job can run per runner at a time. This repo tries to replicate that by limiting the instance to one runner at a time. The `-user-data.sh` script could be modified to run multiple container runners per instance.
- **Launches x64 Ubuntu Linux VMs.** You could change the AMI for ARM64 Graviton, or do some copy/paste to create a Launch Configuration for each platform.

## Usage

1. create a `secrets.tfvars` file in the root of this project with these variables defined:

    ```terraform
    github_token = ""
    aws_access_key = ""
    aws_secret_key = ""
    ```

1. Intalize, plan, and apply the Terraform

    ```shell
    terraform init
    terraform plan -var-file secrets.tfvars
    terraform apply -var-file secrets.tfvars
    ```

## Similar projects for self-hosted runners

- [myoung34/docker-github-actions-runner](https://github.com/myoung34/docker-github-actions-runner), used by this project.
- [philips-labs/terraform-aws-github-runner/](https://github.com/philips-labs/terraform-aws-github-runner/), a much more advanced setup that's great for autoscaling to zero when no jobs are running.
- [evryfs/github-actions-runner-operator/](https://github.com/evryfs/github-actions-runner-operator/), Kubernetes operator for creating runners.
- [actions-runner-controller/actions-runner-controller](https://github.com/actions-runner-controller/actions-runner-controller), Kubernetes controller for creating runners.
