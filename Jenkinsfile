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
    image: dpthub/eos-jenkins-agent-base:latest
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
        stage ('Checkout SCM'){
          git credentialsId: 'git', url: 'https://github.com/maheshangalakurthy/eos-micro-services-admin.git', branch: 'main'
          container('build') {
                stage('Build a Maven project') {
                  //withEnv( ["PATH+MAVEN=${tool mvn_version}/bin"] ) {
                   //sh "mvn clean package"
                  //  }
                  sh "chmod -R 777 ./mvnw"
                  sh './mvnw clean package' 
                  
                   //sh 'mvn clean package'
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
       
        stage('Docker Build and Push') {
        steps {
         
          withDockerRegistry([credentialsId: "docker", url: ""]) {
          sh 'printenv'
          // sh 'sudo docker build -t angalakurthymahesh/eos-micro-services-admin:latest .'
          // sh 'docker push angalakurthymahesh/eos-micro-services-admin:latest'
        }
        }
       }   

        stage ('Helm Chart') {
          container('build') {
            dir('charts') {
              withCredentials([usernamePassword(credentialsId: 'jfrog', usernameVariable: 'username', passwordVariable: 'password')]) {
              sh '/usr/local/bin/helm package micro-services-admin'
              sh '/usr/local/bin/helm push-artifactory micro-services-admin-1.0.tgz https://b11x1xfs5vvmkd3.jfrog.io/artifactory/eos-helm-local --username $username --password $password'
              }
            }
        }
        }
    }
}
