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
        container('build') {
           git credentialsId: 'git', url: 'https://github.com/maheshangalakurthy/eos-micro-services-admin.git', branch: 'main'
           sh 'chmod 0777 *'
        }
      }
        stage ('Checkout SCM'){
          container('build') {
                stage('Build a Maven project') {
                 // sh "chmod -R 777 ./mvnw"
                  sh 'ls -ltr'
                  sh './mvnw clean package' 
                }
            }
        }
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
                    docker.withRegistry( 'https://index.docker.io/v1/', 'docker' ) {
                    def customImage = docker.build("angalakurthymahesh/eos-micro-services-admin:latest")
                    customImage.push()             
                    }
                }
            }
        }
    }
}
