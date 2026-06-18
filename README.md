# Flask Mongo DevOps

A simple User Registration web application built with Python Flask and MongoDB, fully containerized with Docker and deployed on AWS EC2 using a complete DevOps pipeline.

## Tech Stack

- **App:** Python Flask, MongoDB
- **Containerization:** Docker, Docker Compose
- **Infrastructure:** Terraform (AWS EC2)
- **Configuration Management:** Ansible
- **CI/CD:** GitHub Actions
- **Cloud:** AWS EC2

## Project Structure

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

## Infrastructure Setup

1. Navigate to terraform folder:
```bash
    cd terraform
```

2. Initialize and apply:
```bash
    terraform init
    terraform apply
```

3. Note the output IPs for Ansible inventory.

## Configuration Management

1. Update `ansible/inventory.ini` with your EC2 IPs
2. Run the playbook from your Ansible control node:
```bash
    ansible-playbook -i inventory.ini playbook.yml
```

## CI/CD Pipeline

On every push to `main` branch, GitHub Actions automatically:

1. Builds the Docker image
2. Pushes it to DockerHub
3. SSHs into EC2 and deploys the latest image

## Environment Variables

Copy `.env.example` to `.env` and update values:
MONGO_URI=mongodb://mongo:27017/

## Author

Nouman Atiq 
([Github](https://github.com/nomisatti))