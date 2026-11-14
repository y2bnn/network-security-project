#!/bin/bash
# [담당자: 3번 방화벽 구축 & 4번 관리자 접근 제어 담당자]
# [용도: iptables 방화벽 룰셋(Default Deny, 포워딩, SSH 접근제어) 자동 적용 스크립트]

echo "🔥 [Firewall] 방화벽 정책 적용을 시작합니다..."

# 1. 기본 정책 설정 (Default Deny)

# 기본적으로 모든 접근을 차단
iptables -P INPUT DROP
iptables -P FORWARD DROP
# 기존 연결 및 관련 응답 트래픽 허용
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 로컬 루프백 통신 허용
iptables -A INPUT -i lo -j ACCEPT

# 2. HTTP (TCP 80) 포트 포워딩 및 웹 트래픽 허용
# TODO: 3번 담당자가 방화벽 -> DMZ 웹서버(172.30.0.10:80) DNAT 포워딩 룰 작성 영역
# 외부에서 들어오는 HTTP 요청을 DMZ 웹서버로 전달
iptables -t nat -A PREROUTING \
  -p tcp --dport 80 \
  -j DNAT --to-destination 172.30.0.10:80

# DMZ 웹서버로 전달되는 HTTP 트래픽 허용
iptables -A FORWARD \
  -p tcp -d 172.30.0.10 --dport 80 \
  -m conntrack --ctstate NEW \
  -j ACCEPT

# 웹서버의 응답이 방화벽을 거쳐 돌아오도록 SNAT 적용
iptables -t nat -A POSTROUTING \
  -p tcp -d 172.30.0.10 --dport 80 \
  -j SNAT --to-source 172.30.0.2

# 3. 관리자 대역 (Admin Subnet) SSH 접근 통제
# TODO: 4번 담당자가 관리자 IP/대역만 22번 포트 접속 허용 룰 작성 영역

# 4. fail2ban 및 rsyslog 서비스 실행
# TODO: 4번 담당자가 rsyslog & fail2ban service start 구문 작성 영역

echo "✅ [Firewall] 모든 방화벽 정책이 성공적으로 세팅되었습니다."
