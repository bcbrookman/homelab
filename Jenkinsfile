pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: python3
            image: python:3-slim
            command:
            - bash
            tty: true
        '''
    }
  }
  stages {
    stage('setup') {
      steps {
        container('python3') {
          sh "./run.sh -e setup"
        }
      }
    }
    stage('lint') {
      steps {
        container('python3') {
          sh "./run.sh -e lint"
        }
      }
    }
  }
}
