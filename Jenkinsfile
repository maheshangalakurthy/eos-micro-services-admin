def label = "eosagent"
def mvn_version = 'M2'
podTemplate(label: label, yaml: """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: build
  annotations:
    sidecar.istio.io/inject: "false"
spec:
  containers:
  - name: build
    image: angalakurthymahesh/eos-jenkins-agent-base:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - name: dockersock
      mountPath: /var/run/docker.sock
  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock
"""
) {
    node (label) {
      // SCM Checkout
      stage('SCM Checkout') {
        steps {
          git credentialsId: 'git', url: 'https://github.com/maheshangalakurthy/eos-micro-services-admin.git', branch: 'main'
          sh 'chmod 0777 *'
        }
      }

      // stage('Build Artifact') {
      //    container('build') {
      //      stage('Build Artifact') {
      //       steps {
      //         sh "./mvnw clean package -DskipTests=true"
      //         archive 'target/*.jar' 
      //       }
      //   } 
      //  }
      // }

      // stage('Unit Tests and JoCoCo') {
      //    container('build') {
      //      stage('Unit Tests and JoCoCo') {
      //       steps {
      //         sh "./mvnw test"
      //       }
      //   }
      //    }
      // }

      // stage('Mutation Tests - PIT') {
      //    container('build') {
      //      stage('Unit Tests and JoCoCo') {
      //       steps {
      //         sh "./mvnw org.pitest:pitest-maven:mutationCoverage"
      //       }
      //       post {
      //     always {
      //       pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
      //     }
      //   }
      //   }
      //    }
      // }

        stage ('Sonar Scan'){
          container('build') {
                stage('Sonar Scan') {
                  withSonarQubeEnv('sonar') {
                  sh "chmod -R 777 ./mvnw"
                  sh './mvnw verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=cloud4azureaws_eos'
                }
                }
            }
        }

        stage ('Docker Build'){
          container('build') {
                stage('Build Image') {
                    docker.withRegistry( 'https://registry.hub.docker.com', 'docker' ) {
                    def customImage = docker.build("angalakurthymahesh/eos-micro-services-admin:latest")
                    customImage.push()             
                    }
                }
            }
        }
    }
}
