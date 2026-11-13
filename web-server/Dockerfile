# [담당자: 2번 웹서버 구축 담당자]
# [용도: Nginx 웹서버 컨테이너 빌드 및 헬스체크 환경 구성]

FROM nginx:alpine

# Auto-Healing (헬스체크) 동작을 위한 curl 패키지 설치
RUN apk add --no-cache curl

# Nginx 설정 파일 복사
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 시연용 메인 웹페이지 복사
COPY index.html /usr/share/nginx/html/index.html

# 사용자 정의 오류 페이지 복사
COPY 403.html /usr/share/nginx/html/403.html
COPY 404.html /usr/share/nginx/html/404.html

EXPOSE 80

# 웹서버 상태 확인
HEALTHCHECK --interval=5s --timeout=3s \
    --start-period=10s --retries=3 \
    CMD curl -fsS http://127.0.0.1/health > /dev/null || exit 1