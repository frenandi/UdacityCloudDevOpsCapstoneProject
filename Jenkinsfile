pipeline {
    def app
    environment {
        registry = "frenandi/clouddevopscapstoneproject"
        registryCredential = 'dockerhub'
    }
     agent any
     stages {
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
        stage('Build image') {
            app = docker.build("anandr72/nodeapp")
            app = docker.build("my-image:${env.BUILD_ID}", "-f dockerfiles/Dockerfile")
        }
        stage('Push image') {
            docker.withRegistry('https://registry.hub.docker.com', 'docker-hub') {
                app.push("${env.BUILD_NUMBER}")
                app.push("latest")
                } 
                    echo "Trying to Push Docker Build to DockerHub"
        }
     }     
}