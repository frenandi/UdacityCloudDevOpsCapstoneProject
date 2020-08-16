pipeline {
    environment {
        registry = "frenandi/clouddevopscapstoneproject"
        registryCredential = "dockerhub"
        dockerImage = ''
        kubernetesDeployName = "frenandi-site"
        kubernetesDeployYamlFileName = "kubernetesDeployment.yml"
        kubernetesContainerNameFromDeploymentYaml = "frenandi-site"
        kubernetesServiceName = "frenandi-site-kubernetes-service"
        kubernetesPort = 9090
        kubernetesTargetPort = 80
        delete = true
        //hadolintPath = "/var/lib/jenkins/workspace/loudDevOpsCapstoneProject_master@2/hadolint_lint.txt"
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
                    script {
                        def output_list = readFile("hadolint_lint.txt")
                        if (output_list.size() == 0) {
                            currentBuild.result = 'ABORTED'
                            error('There are linting errors')
                        }
                        else{
                            println "File empty"
                        }
                    }
                    /*sh """#!/bin/bash
 
                            if [ -s ${env.WORKSPACE}/hadolint_lint.txt ] ]
                            then
                                error(\"There are linting errors\")
                            else
                                echo "File empty"
                            fi
                        """*/
                    //sh "[ -s ${env.WORKSPACE}/hadolint_lint.txt ] && error(\"There are linting errors\")  || echo \"File empty ${env.WORKSPACE}\""
                    //sh "[ -s ${env.WORKSPACE}/hadolint_lint.txt ] && currentBuild.result = 'ABORTED' ; error('There are linting errors') || echo \"File not empty\""
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