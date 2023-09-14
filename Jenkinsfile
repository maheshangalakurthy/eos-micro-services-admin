pipeline {
  agent any
  environment {
    imageName = "angalakurthymahesh/eos-micro-service-admin:${GIT_COMMIT}"
  }

  stages {

     stage('SCM Checkout') {
        steps {
          sh "git clone https://github.com/maheshangalakurthy/eos-micro-services-admin.git"
        }
      }
      
     stage('Build Artifact - Maven') {
       steps {
         sh "./mvnw clean package -DskipTests=true"
         archive 'target/*.jar'
       }
     }

     stage('Unit Tests - JUnit and JaCoCo') {
       steps {
         sh "./mvnw test"
       }
     }

     stage('Mutation Tests - PIT') {
       steps {
         sh "./mvnw org.pitest:pitest-maven:mutationCoverage"
       }
     }

     stage('SonarQube - SAST') {
       steps {
         withSonarQubeEnv('SonarQube') {
            sh './mvnw verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=cloud4azureaws_eos'
         }
       }
     }
  }
}