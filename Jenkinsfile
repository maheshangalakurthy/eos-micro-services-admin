pipeline {
  agent any
  environment {
    imageName = "angalakurthymahesh/eos-micro-service-admin:${GIT_COMMIT}"
  }

  stages {
    stage ('SCM Checkout') {
      sh "git clone https://github.com/maheshangalakurthy/eos-micro-services-admin.git"
    }

    stage('Build Artifact') {
      sh './mvnw clean package -DskipTests=true'
      archive 'target/*.jar' 
    }

    stage('Unit Tests and JoCoCo') {
            steps {
              sh "./mvnw test"
            }
    }

    stage('Mutation Tests - PIT') {
        steps {
          sh "./mvnw org.pitest:pitest-maven:mutationCoverage"
        }
        post {
          always {
            pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
          }
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