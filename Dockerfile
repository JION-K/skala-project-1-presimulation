# 1. 베이스 이미지 설정 (파이썬 3.11 슬림 버전 사용으로 용량 최적화)
FROM python:3.11-slim

# 2. 컨테이너 내부의 작업 디렉토리 설정
WORKDIR /app

# 3. 운영체제 필수 패키지 업데이트 및 설치 (텐서플로우 등 C++ 기반 라이브러리 구동용)
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 4. 재료 목록표(requirements.txt) 먼저 복사 (도커 캐시를 활용해 빌드 속도 향상)
COPY requirements.txt .

# 5. 파이썬 패키지 설치
RUN pip install --no-cache-dir -r requirements.txt

# 6. 나머지 모든 소스 코드 복사 (model_serving_rpt 폴더 등)
COPY . .

# 7. 외부와 통신할 포트 개방 (젠킨스 파이프라인에 적어둔 8000번 포트)
EXPOSE 8000

# 8. 컨테이너가 켜질 때 실행할 최종 명령어 (실제 서빙 파일명에 맞게 수정 필요)
# 예시: FastAPI를 사용할 경우
CMD ["uvicorn", "model_serving_rpt.main:app", "--host", "0.0.0.0", "--port", "8000"]
# 예시: 일반 파이썬 스크립트를 사용할 경우
# CMD ["python", "app.py"]