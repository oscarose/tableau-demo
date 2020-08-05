peline {
    agent {
        label'master'
    }
    stages {
        stage('build docker image') {
            steps {
                sh """
                docker build -t tableau:2.3.4 .
                """
            }
        }
        stage('tag docker image') {
            steps {
                sh """
                docker tag tableau:2.3.4 docker-registry.default.svc:5000/demo-tableau/tableau:2.3.4
                """
            }
        }
        stage('push docker image') {
            steps {
                sh """
                docker push docker-registry.default.svc:5000/demo-tableau/tableau:2.3.4
                """
            }
        }
        stage('run docker container') {
            steps {
                sh """
                docker run -ti --privileged -v /sys/fs/cgroup:/sys/fs/cgroup -v /run -p 8850:8850 docker-registry.default.svc:5000/demo-tableau/tableau:2.3.4
                """
            }
        }
    }
}
