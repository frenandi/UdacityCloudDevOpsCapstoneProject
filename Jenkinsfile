pipeline {
    environment {
        registry = "frenandi/clouddevopscapstoneproject"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent any
    stages {
        stage('Testing access 1') {
            steps{
                sh "sudo ./kubernetesdeploy.sh ${registry}:${env.BUILD_ID} holamundo"
            }
        }
        stage('Deploy Stack but with file') {
            steps{
                withAWS(region:'us-east-2',credentials:'awscredentials') {
                    sh 'sudo ./create-stack.sh test template1 EKSClusterCloudFormation.yml EKSClusterCloudFormationParameters.json' 
                    sh 'aws cloudformation wait stack-create-complete --stack-name firstClusterTest'
                }
            }
        }
        /*stage('Deploy CloudFormation EKS Cluster') {
            steps{
                withAWS(region:'us-east-2',credentials:'awscredentials') {
                    sh 'aws cloudformation create-stack --stack-name firstClusterTest --template-body file://EKSClusterCloudFormation.yml --parameters file://EKSClusterCloudFormationParameters.json --region us-east-2 --capabilities CAPABILITY_NAMED_IAM' 
                    sh 'aws cloudformation wait stack-create-complete --stack-name firstClusterTest'
                }
            }
        }*/
        stage('Deploy CloudFormation EKS ') {
            steps{
                withAWS(region:'us-east-2',credentials:'awscredentials') {
                    sh 'aws cloudformation create-stack --stack-name firstNodeTest --template-body file://EKSNodeCloudFormation.yml --parameters file://EKSNodeCloudFormationParameters.json --region us-east-2 --capabilities CAPABILITY_NAMED_IAM'
                    sh 'aws cloudformation wait stack-create-complete --stack-name firstNodeTest'
                }
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
        stage('Testing access ') {
            steps{
                sh "./kubernetesdeploy.sh ${registry}:${env.BUILD_ID} holamundo"
            }
        }
    }     
}