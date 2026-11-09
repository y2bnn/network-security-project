# [담당자: 2번 웹서버 구축 담당자]
# [용도: Nginx 웹서버 컨테이너 빌드 및 헬스체크 환경 구성]

FROM nginx:alpine

# Auto-Healing (헬스체크) 동작을 위한 curl 패키지 설치
RUN apk add --no-cache curl

# 시연용 메인 웹페이지 복사
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
