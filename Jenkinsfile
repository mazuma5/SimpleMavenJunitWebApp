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
                sh 'curl -X PUT -u admin:password -T target/my-app-1.0-SNAPSHOT.jar "http://localhost:8081/artifactory/libs-release-local/my-app-1.0-SNAPSHOT.jar"'
            }
        }
        stage('Deploy') {
            steps {
                sh 'java -jar target/my-app-1.0-SNAPSHOT.jar'
            }
        }
    }
}
