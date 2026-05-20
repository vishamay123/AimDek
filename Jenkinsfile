pipeline {

    agent any

    environment {

        IMAGE_NAME = "node-app"

        IMAGE_TAG = "${BUILD_NUMBER}"

        FULL_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"
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

            emailext(

                subject: "SUCCESS: ${env.JOB_NAME} Build ${env.BUILD_NUMBER}",

                body: """
                <h2>Deployment Successful</h2>

                <p>Job Name: ${env.JOB_NAME}</p>

                <p>Build Number: ${env.BUILD_NUMBER}</p>

                <p>Status: SUCCESS</p>

                <p>Docker Image: ${env.FULL_IMAGE}</p>

                <p>Build URL: ${env.BUILD_URL}</p>
                """,

                to: 'vishamay555@gmail.com'
            )
        }

        failure {

            emailext(

                subject: "FAILED: ${env.JOB_NAME} Build ${env.BUILD_NUMBER}",

                body: """
                <h2>Deployment Failed</h2>

                <p>Job Name: ${env.JOB_NAME}</p>

                <p>Build Number: ${env.BUILD_NUMBER}</p>

                <p>Status: FAILED</p>

                <p>Check Logs: ${env.BUILD_URL}</p>
                """,

                to: 'vishamay555@gmail.com'
            )
        }

        always {

            sh 'docker image prune -af || true'
        }
    }
}
