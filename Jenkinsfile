pipeline {
    environment {
        registry = "frenandi/clouddevopscapstoneproject"
        registryCredential = "dockerhub"
        dockerImage = ''
        clusterCloudformationName = "UdacityCloudDevOpsClusterStack"
        clusterCloudformationFileName = "EKSClusterCloudFormation.yml"
        clusterCloudformationParameterFileName = "EKSClusterCloudFormationParameters.json"
        clusterNodeCloudformationName = "UdacityCloudDevOpsClusterNodeStack"
        clusterNodeCloudformationFileName = "EKSNodeCloudFormation.yml"
        clusterNodeCloudformationParameterFileName = "EKSNodeCloudFormationParameters.json"
        kubernetesDeployName = "kubernetesDeployment"
        kubernetesDeployYamlFileName = "kubernetesDeployment.yml"
        kubernetesContainerNameFromDeploymentYaml = "frenandi-site"
        kubernetesServiceName = "frenandi-site-kubernetes-service"
        kubernetesPort = 8080
        kubernetesTargetPort = 9376
    }
    agent any
    stages {
        stage('authorizing sh script run for jenkins'){
            steps{
                sh "chmod +x -R ${env.WORKSPACE}"
            }
        }
        /*
        stage('Deploy Stack but with file') {
            steps{
                withAWS(region:'us-east-2',credentials:'awscredentials') {
                    sh "./create-stack.sh ${clusterCloudformationName} ${clusterCloudformationFileName} ${clusterCloudformationParameterFileName}"
                    sh "./validation-stack.sh ${clusterCloudformationName}"
                }
            }
        }
        stage('Deploy CloudFormation EKS ') {
            steps{
                withAWS(region:'us-east-2',credentials:'awscredentials') {
                    sh "./create-stack.sh ${clusterNodeCloudformationName} ${clusterNodeCloudformationFileName} ${clusterNodeCloudformationParameterFileName}"
                    sh "./validation-stack.sh ${clusterNodeCloudformationName}"
                }
            }
        }*/
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
        stage('set context'){
            steps{
                withAWS(region:'us-east-2',credentials:'awscredentials') {
                    sh "aws eks --region us-east-2 update-kubeconfig --name final-project-udacity-my-real-test"
                }
            }
        }
        stage('First deploy from kubernetes') {
            steps{
                sh "./kubernetesDeployment.sh ${kubernetesDeployYamlFileName} ${kubernetesContainerNameFromDeploymentYaml} ${kubernetesDeployName} ${registry}:${env.BUILD_ID} ${kubernetesServiceName} ${kubernetesPort} ${kubernetesTargetPort}"
            }
        }
    }     
}