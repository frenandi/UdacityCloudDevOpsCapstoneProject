pipeline {
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
     }     
}