#!groovy

pipeline {
  agent none
  stages {
    stage('Docker Build') {
      agent any
      steps {
        script {
          if (env.BRANCH_NAME == 'main') {
            sh 'docker build -t federicopao/formazione_sou_k8s:latest .'
          } else if (env.BRANCH_NAME == 'develop') {
            sh 'docker build -t federicopao/formazione_sou_k8s:prova .'
          } else {
            sh 'docker build -t federicopao/formazione_sou_k8s:test .'
          }
        }
      }
    }
    stage('Docker Push') {
      agent any
      steps {
        script {
          if (env.BRANCH_NAME == 'main') {
            withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
              sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
              sh 'docker push federicopao/formazione_sou_k8s:latest'
            }
          } else if (env.BRANCH_NAME == 'develop') {
            withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
              sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
              sh 'docker push federicopao/formazione_sou_k8s:prova'
            }
          } else {
            withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
              sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
              sh 'docker push federicopao/formazione_sou_k8s:test'
            }
          }
        }
      }
    }
  }
}
