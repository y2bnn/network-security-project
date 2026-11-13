#!/bin/bash
# [담당자: 3번 방화벽 구축 & 4번 관리자 접근 제어 담당자]
# [용도: iptables 방화벽 룰셋(Default Deny, 포워딩, SSH 접근제어) 자동 적용 스크립트]

echo "🔥 [Firewall] 방화벽 정책 적용을 시작합니다..."

# 1. 기본 정책 설정 (Default Deny)
# TODO: 3번 담당자가 iptables -P INPUT DROP / FORWARD DROP 구문 작성 영역

# 2. HTTP (TCP 80) 포트 포워딩 및 웹 트래픽 허용
# TODO: 3번 담당자가 방화벽 -> DMZ 웹서버(172.30.0.10:80) DNAT 포워딩 룰 작성 영역

# 3. 관리자 대역 (Admin Subnet) SSH 접근 통제
# : 4번 담당자가 관리자 IP/대역만 22번 포트 접속 허용 룰 작성 영역
# 허용할 관리자 IP (환경변수로 변경 가능)
ADMIN_IP="${ADMIN_IP:-10.0.0.10}"

#SSH 전용 체인에서 관리자 IP만 허용
iptables -N ADMIN_SSH || exit 1
iptables -A ADMIN_SSH -s "$ADMIN_IP" -j ACCEPT || exit 1
iptables -A ADMIN_SSH -j DROP || exit 1

#다른 INPUT 허용 규칙보다 먼저 SSH 접근 검사
iptables -I INPUT 1 -p tcp --dport 22 -j ADMIN_SSH || exit 1

# 4. fail2ban 및 rsyslog 서비스 실행
# : 4번 담당자가 rsyslog & fail2ban service start 구문 작성 영역

#인증 로그 파일 소유자와 권한 설정
touch /var/log/auth.log || exit 1
chown syslog:adm /var/log/auth.log || exit 1
chmod 640 /var/log/auth.log || exit 1

# 인증 로그 수집 시작
/usr/sbin/rsyslogd || exit 1

#SSH 서버 키 준비 및 설정 검사
ssh-keygen -A || exit 1
/usr/sbin/sshd -t || exit 1

#SSH 서버와 Fail2ban 시작
service ssh start || exit 1
service fail2ban start || exit 1

echo "✅ [Firewall] 모든 방화벽 정책이 성공적으로 세팅되었습니다."
