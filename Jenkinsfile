//author: Avik Mazumder 
pipeline {
    environment{
        registry = "mazuma5/simple-maven-webapp"
        registryCredential = 'Dockerhub'
        dockerImage = ''
        containerId = sh(script: 'docker ps -aqf "name=simple-maven-app"', returnStdout:true)
    }
    agent any
    tools {
        maven 'Maven'
        jdk 'JDK'
    }
    
    stages {
        stage('Cloning Git') {
          steps {
            git 'https://github.com/mazuma5/SimpleMavenJunitWebApp'
          }
        }
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Sonar Scan') {
            steps {
                sh 'mvn sonar:sonar'
            }
        }
        
        stage('Building Image'){
          steps{
            script{
              dockerImage = docker.build registry //+ ":$BUILD_NUMBER"
            }
          }
        }
       stage('Push Image'){
          steps{
            script{
              docker.withRegistry('',registryCredential) {
                dockerImage.push("$BUILD_NUMBER")
              }
            }
          }
    }
   /* stage('Deploy Docker image'){
        steps {
            script {
                def server = Artifactory.server 'artifactory'
                def rtDocker = Artifactory.docker server: server
                //def buildInfo = rtDocker.push('$registry:$BUILD_NUMBER', 'docker')
                //also tried:
                //def buildInfo = rtDocker.push('registry-url/docker/image:latest', 'docker') 
                //the above results in registry/docker/docker/image..
                //server.publishBuildInfo buildInfo
            }
        }
    }*/
    
    stage('Cleanup'){
      /*when{
        not {environment ignoreCase:true, name:'containerId', value:''}
      }*/
      steps {
     /*   sh 'docker stop ${containerId}' //Old
        sh 'docker rm ${containerId}'
          sh 'docker ps -f name=simple-maven-app -q | xargs --no-run-if-empty docker container stop'
          sh 'docker container ls -a -fname=simple-maven-app -q | xargs -r docker container rm'*/
          sshagent(credentials : ['Peekay']) {
               sh 'ssh -tt ec2-user@3.19.65.167 "sudo docker ps -f name=simple-maven-app -q | xargs --no-run-if-empty sudo docker container stop"';
                sh 'ssh -tt ec2-user@3.19.65.167 "sudo docker container ls -a -fname=simple-maven-app -q | xargs -r sudo docker container rm"';
            }
      }
    }
    
    stage('Deploy'){
        steps{
            sshagent(credentials : ['Peekay']) {
                //sh 'ssh -o StrictHostKeyChecking=no ec2-user@3.19.65.167 uptime'
                //sh 'ssh -v ec2-user@3.19.65.167'
                //sh 'scp ./source/filename user@hostname.com:/remotehost/target'
                sh 'ssh -tt -o TCPKeepAlive=yes -o ServerAliveInterval=30 ec2-user@3.19.65.167 "sudo docker run --name=simple-maven-app -d -p 3000:8080 $registry:$BUILD_NUMBER"'
                //sh ' ssh -i 3.19.65.167'
            }
        }   
    }
    
    /*stage('Run Container'){
        steps{
            sh 'docker run --name=simple-maven-app -d -p 3000:8080 $registry:$BUILD_NUMBER &'
        }
     }*/
        /*stage('Upload') {
            steps {
                sh 'curl -X PUT -u admin:password -T target/SimpleMavenJunitWebApp.war "http://localhost:8081/artifactory/libs-release-local/SimpleMavenJunitWebApp.war"'
            }
        }
        stage('Deploy') {
            steps {
                sh 'sudo cp -f target/SimpleMavenJunitWebApp.war /usr/share/tomcat/webapps'
            }
        }
        
        stage('Deploy the app'){
            steps{
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                        configs: 'Application.yml',
                        enableConfigSubstitution: false
                )
            }
        }*/
    }
}
