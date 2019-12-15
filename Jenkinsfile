pipeline {
  environment {
    registry = "sorix6/capstone-project"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  
  agent any
  
  stages {
    stage('Checking out git repo') {
        steps {
            script {
                echo 'Checkout Git repository'
                checkout scm
            }
        }
    }
    stage("Linting") {
      steps {
        script {
          echo 'Linting...'
          docker.image('hadolint/hadolint:latest-debian').inside() {
            /*
             * Run the linter on the Dockerfile
             * - save any errors to a lof file
             * - if errors, stop build, display errors and remove errors file
             */
            sh 'truncate -s 0 linting_results.log'
            sh 'hadolint ./Dockerfile | tee -a linting_results.log'
            sh '''
                lintErrors=$(stat --printf="%s"  linting_results.log)
                if [ "$lintErrors" -gt "0" ]; then
                    echo "The following errors were found:"
                    cat linting_results.log
                   
                    sh 'truncate -s 0 linting_results.log'
                    exit 1
                else
                    echo "No errors were found on your Dockerfile"
                fi
            '''
          }
        }
      }
    }
    stage('Building image and pushing to Dockerhub') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
          
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
    stage('Deploying to AWS') {
        steps {
            script {
                dir ('./') {
                    withAWS(credentials: 'aws-credentials-eks', region: 'us-west-2') {
                        sh "./infrastructure/update-kubeconfig.sh"
                        sh "kubectl apply -f ./infrastructure/aws-auth-cm.yml"
                        sh "kubectl apply -f ./deployment/capstone-project.yml"
                        sh "kubectl get nodes"
                        sh "kubectl get pods"
                        sh "./infrastructure/update-kubernetes-worker-nodes.sh"
                    }
                }
            }
        }
    }
    
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
  }
}