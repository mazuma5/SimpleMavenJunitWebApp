//author: Avik mazumder mazuma5
pipeline {
    agent any
    tools {
        maven 'maven3.6.0'
        jdk 'java1.8.0'
    }
    stages {
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
        stage('Upload') {
            steps {
                sh 'curl -X PUT -u admin:password -T target/SimpleMavenJunitWebApp.war "http://localhost:8081/artifactory/libs-release-local/SimpleMavenJunitWebApp.war"'
            }
        }
        stage('Deploy') {
            steps {
                sh 'sudo cp -f target/SimpleMavenJunitWebApp.war /usr/share/tomcat/webapps'
            }
        }
    }
}
