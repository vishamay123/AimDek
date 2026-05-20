pipeline {

    agent any

    environment {

        IMAGE_NAME = "node-app"

        IMAGE_TAG = "${BUILD_NUMBER}"

        FULL_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"

        EMAIL = "vishamay555@gmail.com"
    }

    stages {

        stage('Clone Repository') {

            steps {

                git branch: 'dev',
                url: 'https://github.com/vishamay123/AimDek.git'
            }
        }

        stage('Build Docker Image') {

            steps {

                sh 'docker build -t $FULL_IMAGE .'
            }
        }

        stage('Show Docker Images') {

            steps {

                sh 'docker images'
            }
        }

        stage('Manual Approval') {

            steps {

                input message: 'Deploy to Production?', ok: 'Deploy'
            }
        }

        stage('Stop Old Container') {

            steps {

                sh 'docker compose down || true'
            }
        }

        stage('Deploy New Container') {

            steps {

                sh 'docker compose up -d --build'
            }
        }

        stage('Health Check') {

            steps {

                sh '''
                sleep 10

                curl -f http://localhost:3000
                '''
            }
        }
    }

    post {

        success {

            mail(
                to: "${EMAIL}",
                subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
Deployment Successful

Job Name: ${env.JOB_NAME}

Build Number: ${env.BUILD_NUMBER}

Docker Image: ${env.FULL_IMAGE}

Build URL:
${env.BUILD_URL}
"""
            )
        }

        failure {

            mail(
                to: "${EMAIL}",
                subject: "FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
Pipeline Failed

Job Name: ${env.JOB_NAME}

Build Number: ${env.BUILD_NUMBER}

Check Logs:
${env.BUILD_URL}
"""
            )
        }

        always {

            sh 'docker image prune -af || true'
        }
    }
}
