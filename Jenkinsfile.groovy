@Library('my-shared-libary')

pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'my-docker-repo/wowcher'
        DOCKER_TAG = 'latest'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/sarangsohail/wowcher'
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }
        
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-docker-creds', usernameVariable: 'sarang', passwordVariable: 'sohail')]) {
                    sh "docker login -u $USERNAME -p $PASSWORD"
                }
                sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
            }
        }
    }
}
