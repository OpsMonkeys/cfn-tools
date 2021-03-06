pipeline {
  libraries {
    lib 'jenkins_pipeline_shared@main'
  }
  environment {
    imagename = 'harbor.kacsh.com/library/cfn-tools'
    registryCredential = 'harbor-docker'
    dockerImage = ''
    registryUri = 'https://harbor.kacsh.com'
    imageLine = 'harbor.kacsh.com/library/cfn-tools:$BUILD_NUMBER'
  }
  agent {
    kubernetes {
      label 'test-demo'
      defaultContainer 'docker'
      yamlFile 'jenkins.yaml'
}
   }
  stages {
    stage ('Start') {
      steps {
        // send build started notifications
        sendNotifications 'STARTED'
      }
    }
    stage('Cloning Git') {
      steps {
        git([url: 'https://github.com/kkacsh321/cfn_tools.git', branch: 'main', credentialsId: 'kkacsh321-github'])

      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build imagename
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
          docker.withRegistry( registryUri, registryCredential ) {
             dockerImage.push('$BUILD_NUMBER')
          }
        }
      }
    }
    stage('Analyze with Anchore plugin') {
      steps {
        writeFile file: 'anchore_images', text: imageLine
        anchore bailOnFail: false, engineRetries: '900', name: 'anchore_images'
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( registryUri, registryCredential ) {
             dockerImage.push('latest')
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $imagename:$BUILD_NUMBER"
         sh "docker rmi $imagename:latest"

      }
    }
    stage('Add property file') {
      steps{
        sh "echo $BUILD_NUMBER > build.properties"
         archive 'build.properties'

      }
    }
  }
  post {
    always {
      sendNotifications currentBuild.result
    }
  }
}
