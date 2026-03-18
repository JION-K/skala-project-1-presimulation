pipeline {
    agent any

    environment {
        IMAGE_NAME      = 'skala-mlops-app'
        IMAGE_TAG       = "${BUILD_NUMBER}"
        CONTAINER_NAME  = 'skala-project-1-presimulation'

        // FastAPI/Flask 포트 (필요시 수정)
        APP_PORT        = '8000' 
        HOST_PORT       = '8000'
    }

    stages {
        // 🚨 주의: Pipeline script from SCM 방식을 쓰면, 
        // 젠킨스가 Jenkinsfile을 읽으면서 소스코드도 알아서 다운로드(Checkout) 합니다.
        // 따라서 기존에 있던 Checkout stage는 삭제했습니다!

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f $CONTAINER_NAME || true

                    docker run -d \
                      --name $CONTAINER_NAME \
                      -p $HOST_PORT:$APP_PORT \
                      $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        success {
            echo "✅ ML 서빙 App 배포 성공: ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo '❌ ML 서빙 App 배포 실패'
        }
    }
}