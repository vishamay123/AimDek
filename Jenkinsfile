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
                echo "Waiting for application..."

                sleep 15

                curl -f http://localhost:80                '''
            }
        }
    }

    post {

        success {

            mail(
                to: "${EMAIL}",

                subject: "SUCCESS - ${env.JOB_NAME} #${env.BUILD_NUMBER}",

                body: """
==================================================

        DEPLOYMENT SUCCESSFUL

==================================================

Job Name:
${env.JOB_NAME}

Build Number:
${env.BUILD_NUMBER}

Docker Image:
${env.FULL_IMAGE}

Build URL:
${env.BUILD_URL}

Deployment Time:
${new Date()}

==================================================

Application deployed successfully.

==================================================
"""
            )
        }

        failure {

            mail(
                to: "${EMAIL}",

                subject: "FAILED - ${env.JOB_NAME} #${env.BUILD_NUMBER}",

                body: """
==================================================

        DEPLOYMENT FAILED

==================================================

Job Name:
${env.JOB_NAME}

Build Number:
${env.BUILD_NUMBER}

Check Logs:
${env.BUILD_URL}

Failure Time:
${new Date()}

==================================================

Pipeline execution failed.

Please check Jenkins logs immediately.

==================================================
"""
            )
        }

        always {

            sh 'docker image prune -af || true'
        }
    }
}
