pipeline {
    environment {
        registry = "frenandi/clouddevopscapstoneproject"
        registryCredential = "dockerhub"
        dockerImage = ''
        /*clusterCloudformationName = "UdacityCloudDevOpsClusterStack"
        clusterCloudformationFileName = "EKSClusterCloudFormation.yml"
        clusterCloudformationParameterFileName = "EKSClusterCloudFormationParameters.json"
        clusterNodeCloudformationName = "UdacityCloudDevOpsClusterNodeStack"
        clusterNodeCloudformationFileName = "EKSNodeCloudFormation.yml"
        clusterNodeCloudformationParameterFileName = "EKSNodeCloudFormationParameters.json"*/
        kubernetesDeployName = "frenandi-site"
        kubernetesDeployYamlFileName = "kubernetesDeployment.yml"
        kubernetesContainerNameFromDeploymentYaml = "frenandi-site"
        kubernetesServiceName = "frenandi-site-kubernetes-service"
        kubernetesPort = 9090
        kubernetesTargetPort = 80
        delete = true
    }
    agent any
    stages {
        stage('authorizing sh script run for jenkins'){
            steps{
                sh "chmod +x -R ${env.WORKSPACE}"
            }
        }
        /*stage('Deploy CloudFormation EKS Cluster') {
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
        stage('First deploy from  kubernetes') {
            steps{
                withAWS(region:'us-east-2',credentials:'awscredentials') {
                    sh "./kubernetesDeployment.sh ${kubernetesDeployYamlFileName} ${kubernetesDeployName} ${kubernetesContainerNameFromDeploymentYaml} ${registry}:${env.BUILD_ID} ${kubernetesServiceName}"
                }
            }
        }
        /*stage('Input value to delete rollout'){
            steps {
                script {
                    ${delete} = input(
                            id: 'Proceed', message: 'Is Everything ok with the deploy?', parameters: [
                            [$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Proceed with delete?']
                    ])
                }
            }
        }
        stage('UAT deployment') {
            when {
                expression { ${delete} == true }
            }
            steps {
                withAWS(region:'us-east-2',credentials:'awscredentials') {
                    sh "kubectl rollout status deployments/frenandi-site"
                }
            }
        }*/
    }     
}