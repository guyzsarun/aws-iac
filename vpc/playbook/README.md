# VPC Ansible Playbooks

This directory contains Ansible playbooks for configuring EC2 instances in the VPC.

## Files

- `init-docker.yaml` - Installs Docker and Docker Compose on the public instance
- `init-wordpress.yaml` - Installs WordPress and related components
- `inventory.ini` - Ansible inventory file with bastion jump host configuration

## Prerequisites

- Ansible installed on your local machine
- SSH key pair for EC2 instances
- Access to the bastion host

## Configuration

### Update Inventory File

Edit `inventory.ini` and replace the mock IPs with real values:

1. **Bastion host public IP** (line 5 and line 11):
   ```ini
   bastion_host ansible_host=<BASTION_PUBLIC_IP>
   ```

2. **Public instance private IP** (line 2):
   ```ini
   public_instance ansible_host=<PUBLIC_INSTANCE_PRIVATE_IP>
   ```

3. **SSH key path** (lines 9 and 14):
   ```ini
   ansible_ssh_private_key_file=~/.ssh/your-key.pem
   ```
   Replace with the path to your actual SSH private key.

## Usage

### Install Docker and Docker Compose

```bash
cd vpc/playbook
ansible-playbook -i inventory.ini init-docker.yaml
```

This will:
- Update system packages
- Install Docker
- Install Docker Compose (latest version)
- Start and enable Docker service
- Add ec2-user to docker group

### Install WordPress

```bash
cd vpc/playbook
ansible-playbook -i inventory.ini init-wordpress.yaml
```

## How It Works

The playbooks use SSH ProxyJump to connect to instances in private subnets through the bastion host:

```
Your Machine → Bastion Host (Public IP) → Target Instance (Private IP)
```

The ProxyJump configuration is defined in `inventory.ini`:
```ini
ansible_ssh_common_args='-o ProxyJump=ec2-user@<BASTION_IP> -o StrictHostKeyChecking=no'
```

## Troubleshooting

### Test SSH Connection

Test bastion connection:
```bash
ssh -i ~/.ssh/your-key.pem ec2-user@<BASTION_PUBLIC_IP>
```

Test connection through bastion to public instance:
```bash
ssh -i ~/.ssh/your-key.pem -J ec2-user@<BASTION_PUBLIC_IP> ec2-user@<PUBLIC_INSTANCE_PRIVATE_IP>
```

### Verify Ansible Connectivity

```bash
ansible -i inventory.ini public -m ping
```

### Get Terraform Outputs

Get the IPs from Terraform:
```bash
cd vpc
terraform output bastion_instance_public_ip
terraform output public_instance_private_ip
```

## Notes

- The bastion host acts as a jump server for all SSH connections to private instances
- Docker Compose is installed from the latest GitHub release
- After installation, you may need to log out and back in for docker group membership to take effect