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
                    sh 'if [[ -s dockerfiles/hadolint_lint.txt ]]; then echo "file has something"; else echo "file is empty"; fi'
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
    }     
}