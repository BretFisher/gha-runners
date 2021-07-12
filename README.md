# Simple Terra

Terraform to create GitHub Action self-hosted runners in EC2 using a Launch Configuration.

There are other projects (listed below) for creating self-hosted runners that dynamically scale based on job queues and other advanced setups. My example is only meant to be a way for you to create a fixed set of runners.

## Features

- **Uses Terraform.** You can also use Terraform Cloud.
- **Uses a EC2 Launch Configuration so everything's simle and reproducible.** Launch Configurations create an Auto Scaling Group of instances based on the number of runners you specify.
- **Installs Docker, and runs the runner in a container.** Uses the [myoung34/docker-github-actions-runner](https://github.com/myoung34/docker-github-actions-runner) project to run the runner in Docker, and then bind-mounts the host Docker socket so your Jobs can do Docker things.
- **Updates the instances via [ASG rolling refresh](https://aws.amazon.com/blogs/compute/introducing-instance-refresh-for-ec2-auto-scaling/)** on Terraform changes to the Launch Configuration.
- **Auto updates the runner version.** This is a feature of all GitHub runners. Note that the Ubuntu host OS, Docker, and the Docker image aren't auto-updated, but the ASG rolling refresh will update them to latest on each Terraform change of the Launch Configuration.
- **Dynamically adds/removes runners** from a org/repo using a GitHub Personal Access Token (PAT).
- **Uses spot instances** when possible to save you cash.

## Limits

- **Doesn't enable autoscaling for the ASG.** You could setup CPU/Memory in the Launch Configuration. There are also other projects that do this much more intelligently and autoscale based on runner jobs.
- **Runs one container (runner) per EC2 instance.** First, GitHub doesn't officially support runners inside a container. Their runners are inside a full VM, and only one Job can run per runner at a time. This repo tries to replicate that by limiting the instance to one runner at a time. The `-user-data.sh` script could be modified to run multiple container runners per instance.
- **Launches x64 Ubuntu Linux VMs.** You could change the AMI for ARM64 Graviton, or do some copy/paste to create a Launch Configuration for each platform.
- **No persistent EBS across runner refresh.** This will affect self-hosted runner caches, which may or may not be a problem for you. I use docker ["cache-from image"](https://github.com/docker/build-push-action/blob/master/docs/advanced/cache.md#registry-cache) in Actions to keep image build times efficient, so I rarely need runner caching.
- **No monitoring of runners.** In a real setup you'd likely want instance monitoring enabled.
- **No auto updating of the Host OS, Docker, or the runner image.**  This could be overcome by adding `max_instance_lifetime` to the `aws_autoscaling_group`. See the [Terraform docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) for more info.
- **Rolling refresh doesn't wait for Job completion before shutting down instances.** This causes Workflows to fail, but you can re-run the Job manually.

## Usage

1. Modify the values in variables.tf to your liking.
1. This project defaults to runners connecting to a single repo. To change to a full org, modify the values in `variables.tf` and swap the docker command in `user-data.sh`.
1. Create a `terraform.tfvars` file in the root of this project with these variables defined. If you forked this repo, `.gitignore` prevents committing any `tfvars` files:

    ```terraform
    # terraform.tfvars file for secrets
    github_token = ""
    aws_access_key = ""
    aws_secret_key = ""
    ```

1. Initialize, plan, and apply the Terraform

    ```shell
    terraform init
    terraform plan
    terraform apply
    ```

## Similar projects for self-hosted runners

- [myoung34/docker-github-actions-runner](https://github.com/myoung34/docker-github-actions-runner), used by this project.
- [philips-labs/terraform-aws-github-runner/](https://github.com/philips-labs/terraform-aws-github-runner/), a much more advanced setup that's great for autoscaling to zero when no jobs are running.
- [evryfs/github-actions-runner-operator/](https://github.com/evryfs/github-actions-runner-operator/), Kubernetes operator for creating runners.
- [actions-runner-controller/actions-runner-controller](https://github.com/actions-runner-controller/actions-runner-controller), Kubernetes controller for creating runners.
