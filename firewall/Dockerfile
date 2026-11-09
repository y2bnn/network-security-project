# ==============================================================================
# [담당자: 3번 방화벽 구축 & 4번 관리자 접근 제어 담당자]
# [용도: Ubuntu 기반 방화벽 컨테이너 환경 설정 및 필수 패키지 설치]
# ==============================================================================
FROM ubuntu:latest

# 시스템 업데이트 및 방화벽/보안 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    iptables \
    openssh-server \
    fail2ban \
    rsyslog \
    sudo \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 실행 스크립트 복사
COPY setup-rules.sh /usr/local/bin/setup-rules.sh
RUN chmod +x /usr/local/bin/setup-rules.sh

EXPOSE 80 22

CMD ["/bin/bash", "-c", "/usr/local/bin/setup-rules.sh && tail -f /dev/null"]
