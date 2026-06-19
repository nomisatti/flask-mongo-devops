# Flask Mongo DevOps

A User Registration web application built with Python Flask and MongoDB, fully containerized with Docker and deployed on AWS EC2 using a complete automated DevOps pipeline.

## Tech Stack

- **App:** Python Flask, MongoDB
- **Containerization:** Docker, Docker Compose
- **Infrastructure:** Terraform (AWS EC2)
- **Configuration Management:** Ansible
- **CI/CD:** GitHub Actions
- **Cloud:** AWS EC2
- **Registry:** DockerHub

## Project Structure

```
flask-mongo-devops/
├── app/
│   ├── app.py
│   ├── requirements.txt
│   ├── Dockerfile
│   └── templates/
│       └── index.html
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
├── ansible/
│   ├── playbook.yml
│   ├── inventory.ini.example
│   └── ansible.cfg
├── .github/
│   └── workflows/
│       └── deploy.yml
├── docker-compose.yml
├── .env.example
└── README.md
```

## CI/CD Pipeline Flow

On every push to `master` branch, GitHub Actions automatically:

1. Checks out the code
2. Logs into DockerHub
3. Builds Docker image and pushes to DockerHub
4. SSHs into AWS EC2
5. Pulls latest code from GitHub
6. Pulls latest image from DockerHub
7. Restarts containers with `docker compose up -d`

```
Push to GitHub
    → GitHub Actions triggers
        → Build & push image to DockerHub
        → SSH into EC2
            → git pull
            → docker compose pull
            → docker compose up -d
                → App live on EC2
```

## Prerequisites

- Docker & Docker Compose
- Terraform
- Ansible
- AWS Account
- GitHub Account
- DockerHub Account

## Local Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/flask-mongo-devops.git
cd flask-mongo-devops
```

2. Create `.env` file from example:
```bash
cp .env.example .env
```

3. Run with Docker Compose:
```bash
docker compose up --build -d
```

4. Access the app at `http://localhost:5000`

## Infrastructure Setup (One Time)

### 1. Provision EC2 with Terraform

```bash
cd terraform
terraform init
terraform apply
```

Note both output IPs:
- `flask_app` IP — for the app server
- `ansible_control` IP — for Ansible control node

### 2. Configure EC2 with Ansible

Update `ansible/inventory.ini` with your Flask EC2 IP:
```ini
[webservers]
flask_server ansible_host=YOUR_EC2_IP ansible_user=ubuntu

[all:vars]
ansible_ssh_private_key_file=~/.ssh/your-key
ansible_python_interpreter=/usr/bin/python3
```

SSH into Ansible control node and run:
```bash
ansible-playbook -i inventory.ini playbook.yml
```

This installs Docker on the Flask EC2.

### 3. Initial EC2 App Setup

SSH into Flask EC2 and run once:
```bash
git clone https://github.com/yourusername/flask-mongo-devops.git
cd flask-mongo-devops
# .env is handled automatically by GitHub Actions on every deploy
docker compose up -d
```

After this, all future deployments are handled automatically by GitHub Actions.

## GitHub Secrets Setup

Go to: Repo → Settings → Secrets and variables → Actions → New repository secret

| Secret | Description |
|---|---|
| `EC2_HOST` | Public IP of Flask EC2 |
| `EC2_USERNAME` | SSH user — `ubuntu` |
| `EC2_KEY` | Contents of your private key file |
| `DOCKERHUB_USERNAME` | Your DockerHub username |
| `DOCKERHUB_TOKEN` | DockerHub access token (not password) |
| `ENV_FILE` | Full contents of your `.env` file |

### How to get DockerHub Token:
1. Login to DockerHub
2. Account Settings → Security → New Access Token
3. Copy and save as `DOCKERHUB_TOKEN` secret

### How to get EC2 Private Key:
```bash
cat your-key-file
```
Copy entire output including `-----BEGIN OPENSSH PRIVATE KEY-----` and paste as `EC2_KEY` secret.

## Environment Variables

Copy `.env.example` to `.env` and update values:

```
MONGO_URI=mongodb://mongo:27017/
DOCKER_IMAGE=yourdockerhubusername/flask-mongo-devops:latest
```

## Cost Warning

> ⚠️ Remember to stop EC2 instances when not in use to avoid charges.

Stop from AWS Console or destroy completely:
```bash
terraform destroy
```

## Author

Nouman Atiq 
([Github](https://github.com/nomisatti))