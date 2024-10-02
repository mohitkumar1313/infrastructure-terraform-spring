pipeline {
    agent any

    environment {
        TERRAFORM_DIR = "."  // Directory where Terraform files are located
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Clone the Terraform repository
                git 'https://github.com/your-username/terraform-repo.git'
            }
        }

        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                // Generate Terraform plan
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform plan -out=plan.out'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply the Terraform plan
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform apply -auto-approve plan.out'
                }
            }
        }
    }
}
