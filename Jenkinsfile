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
        maven 'maven3.6.0'
        jdk 'java1.8.0'
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
        stage('Building Image'){
          steps{
            script{
              dockerImage = docker.build registry + ":$BUILD_NUMBER"
            }
          }
        }
        stage('Push Image'){
      steps{
        script{
          docker.withRegistry('',registryCredential) {
            dockerImage.push()
          }
        }
      }
    }
    
    stage('Cleanup'){
      when{
        not {environment ignoreCase:true, name:'containerId', value:''}
      }
      steps {
        sh 'docker stop ${containerId}'
        sh 'docker rm ${containerId}'
      }
    }
    stage('Run Container'){
        steps{
            sh 'docker run --name=simple-maven-app -d -p 3000:3000 $registry:$BUILD_NUMBER &'
        }
     }
        /*stage('Upload') {
            steps {
                sh 'curl -X PUT -u admin:password -T target/SimpleMavenJunitWebApp.war "http://localhost:8081/artifactory/libs-release-local/SimpleMavenJunitWebApp.war"'
            }
        }
        stage('Deploy') {
            steps {
                sh 'sudo cp -f target/SimpleMavenJunitWebApp.war /usr/share/tomcat/webapps'
            }
        }*/
    }
}
