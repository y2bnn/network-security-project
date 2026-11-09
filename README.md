# Secure 3-Tier Network & Auto-Healing Web Service

도커 기반의 DMZ 3계층 망 분리, Fail2ban 동적 방화벽 차단, Healthcheck 기반 오토힐링, 그리고 로컬 바인딩 보안 관제(Portainer)를 결합한 실무 인프라 보안 프로젝트입니다.

## 시스템 아키텍처 (3계층 망 분리)
외부 위협으로부터 내부 시스템을 보호하기 위해, 네트워크를 단일 구조가 아닌 3개의 독립된 가상 브리지로 완전히 격리했습니다.

- `public-net` (외부망): 외부 사용자가 접근하는 공인/외부 통신 대역 (`172.20.0.0/24`)
- `dmz-net` (DMZ 비무장지대): `internal: true` 옵션을 적용하여 외부 인터넷과 직접 출입을 차단한 격리된 웹서버 대역 (`172.30.0.0/24`)
- `admin-net` (관리자망): 관리자 및 관제 시스템이 위치하는 안전한 내부 통신 대역 (`10.0.0.0/24`)

## 핵심 보안 기능

### - DMZ 3계층 망 분리 & Auto-Healing (자동 복구)
- **망 격리:** 웹서버가 침해사고를 당하더라도, 격리된 DMZ 구조 덕분에 공격자가 관리자망이나 방화벽 내부 권한으로 확산하는 것을 원천 방어합니다.
- **오토힐링:** 도커 `healthcheck` (5초 주기 `curl` 생존 확인)와 `restart: always` 정책을 결합하여, 웹서버 장애 발생 시 5초 이내에 자동 복구됩니다.

### - L4 패킷 필터링 + Fail2ban (동적 IP 실시간 자동 차단)
- **Default Deny:** `iptables` 기반 기본 방화벽 정책으로 허용된 트래픽 외 모든 접근을 차단합니다.
- **Fail2ban 연동:** 관리자 SSH 로그인 실패가 3회 이상 감지되면, 공격자의 IP를 방화벽 룰셋에 즉시 자동 등록하여 실시간으로 차단합니다.

### - 관리자 전용 웹 GUI 대시보드 (Portainer) 보안
- 도커 전체를 제어할 수 있는 Portainer 대시보드를 도입하되, 외부 스캔 노출을 차단하기 위해 로컬 호스트 전용 (`127.0.0.1:9000:9000`)으로 바인딩하여 공격 표면을 최소화했습니다.

## 프로젝트 구조
```text
.
├── docker-compose.yml       # 3계층 망 분리 및 전체 인프라 통합 컴포즈
├── firewall/
│   ├── Dockerfile           # 방화벽 컨테이너 이미지 설정 (iptables, fail2ban)
│   └── setup-rules.sh       # 방화벽 룰셋 자동 적용 및 SSH/Fail2ban 연동 스크립트
├── web-server/
│   ├── Dockerfile           # 웹서버 이미지 설정 (Nginx, curl 설치)
│   ├── nginx.conf           # Nginx 웹서버 구성 파일
│   └── index.html           # 보안 관제 센터 콘셉트의 메인 대시보드 페이지
└── scripts/
    └── test-security.sh     # 보안성 테스트 및 검증 자동화 스크립트
```

## 실행 방법 (Quick Start)

1. 저장소 클론 및 프로젝트 디렉토리 이동 후, 아래 명령어로 컨테이너를 빌드하고 백그라운드에서 실행합니다.
   ```text
   docker-compose up -d --build
   ```

2. 웹서버 정상 동작 확인 (메인 관제 페이지 접속)
   - 방화벽을 거쳐 80번 포트로 접속하여 `index.html` 대시보드 화면 확인

3. 자동 복구(Auto-Healing) 시연
   ```text
   docker kill secure-web
   ```

## 팀원 소개 및 담당 업무

<div align="center">

| **팀원 이름** | **담당 파트** | **주요 작업 내용** |
| :---: | :---: | :--- |
| **[@y2bnn](https://github.com/y2bnn)** | 네트워크 구성 | • DMZ 3계층 망 분리 (`docker-compose.yml`)<br>• 웹서버 헬스체크 및 Portainer 로컬 바인딩 연동 |
| **[@sujin0607](https://github.com/sujin0607)** | 웹서버 구축 | • Nginx 기반 웹서버 컨테이너 빌드<br>• 관제 대시보드 (`index.html`) 및 헬스체크용 `curl` 패키지 구성 |
| **[@yujin4545](https://github.com/yujin4545)** | 방화벽 구축 | • Ubuntu 기반 방화벽 컨테이너 생성<br>• `iptables` Default Deny 및 `fail2ban` 패키지 연동 기반 마련 |
| **[@seojin015](https://github.com/seojin015)** | 관리자 접근 제어 | • 관리자 SSH 접속 통제 룰셋 설정<br>• SSH 로그인 3회 실패 시 동적 차단(Fail2ban) 연동 검증 |
| **[@sooyeon](https://github.com/sooyeon)** | 검증 및 발표 | • 보안성 테스트 및 검증 자동화 스크립트 (`test-security.sh`) 작성<br>• 시연 영상 녹화 및 발표 자료 제작 |

</div>
