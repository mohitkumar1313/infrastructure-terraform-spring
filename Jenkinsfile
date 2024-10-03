pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY')
        AWS_REGION = 'ca-central-1'
    }

    stages {
        
        stage('Clone Terraform Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/mohitkumar1313/infrastructure-terraform-spring.git'
            }
        }

        
        stage('Pull Docker Image') {
            steps {
                script {
                    def appImage = docker.image('mohitsalgotra/scale-springapp:latest')
                    appImage.pull()
                }
            }
        }

        
        stage('Install AWS CLI') {
            steps {
                script {
                    sh '''
                    # Download AWS CLI
                    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

                    # Unzip the file, force overwrite any existing files
                    unzip -o awscliv2.zip

                    # Install AWS CLI with sudo (ensure Jenkins has sudo privileges)
                    sudo ./aws/install --update
                    '''
                }
            }
        }

       
        stage('Terraform Init') {
            steps {
                script {
                    sh '''
                    terraform init
                    '''
                }
            }
        }

        
        stage('Terraform Plan') {
            steps {
                script {
                    sh '''
                    terraform plan
                    '''
                }
            }
        }

        
        stage('Terraform Apply') {
            steps {
                script {
                    sh '''
                    terraform apply -auto-approve
                    '''
                }
            }
        }

        
        stage('Wait for EC2 to Initialize') {
            steps {
                script {
                    echo "Waiting for EC2 instance to fully initialize..."
                    sleep(time: 2, unit: 'MINUTES')  
                }
            }
        }

        
        stage('Deploy Docker Image to EC2') {
            steps {
                script {
                    def instanceId = sh(script: "terraform output -raw instance_id", returnStdout: true).trim()

                    withCredentials([sshUserPrivateKey(credentialsId: 'new-ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                        sh '''
                        # Get the public IP of the EC2 instance
                        PUBLIC_IP=$(aws ec2 describe-instances \
                            --instance-ids ''' + instanceId + ''' \
                            --query 'Reservations[0].Instances[0].PublicIpAddress' \
                            --output text)
                        
                        echo "EC2 Public IP: $PUBLIC_IP"
                        
                        # SSH into the EC2 instance and deploy the Docker image
                        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $SSH_KEY ubuntu@$PUBLIC_IP \
                        "sudo docker pull mohitsalgotra/scale-springapp:latest && \
                         sudo docker run -d -p 8081:8081 mohitsalgotra/scale-springapp:latest"
                        '''
                    }
                }
            }
        }
    }
}
