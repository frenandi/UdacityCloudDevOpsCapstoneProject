pipeline {
    environment {
        registry = "frenandi/clouddevopscapstoneproject"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent any
    stages {
        stage('Deploy CloudFormation EKS Cluster') {
            steps{
                sh './create-stack.sh firstClusterTest EKSClusterCloudFormation.yml EKSClusterCloudFormationParameters.json'
                sh 'aws cloudformation wait stack-create-complete --stack-name firstClusterTest'
            }
        }
        stage('Deploy CloudFormation EKS ') {
            steps{
                sh './create-stack.sh firstNodeTest EKSNodeCloudFormation.yml EKSNodeCloudFormationParameters.json'
                sh 'aws cloudformation wait stack-create-complete --stack-name firstNodeTest'
            }
        }
        stage('Build') {
            steps {
                sh 'echo "Hello World!!!"'
                sh '''
                    echo "Multiline shell steps works too"
                    ls -lah
                '''
            }
        }
        stage ("lint dockerfile") {
            agent {
                docker {
                    image 'hadolint/hadolint:latest-debian'
                }
            }
            steps {
                sh 'hadolint dockerfiles/* | tee -a hadolint_lint.txt'
            }
            post {
                always {
                    archiveArtifacts 'hadolint_lint.txt'
                }
            }
        }
        stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build("${registry}:${env.BUILD_ID}", "-f dockerfiles/Dockerfile .")
                }
            }
        }
        stage('Deploy Image') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }
        
    }     
}