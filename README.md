# AWS 를 활용한 인프라 구성 프로젝트
**팀원:** 이상윤 / 김민주 / 김한수 / 문한성

**기간:** 2023.06.12~2022.06.30

## 간략한 설명
AWS 클라우드 인프라를 구축하는 프로젝트입니다. 주제는 마라톤 대회 기록 시스템으로, 목표는 마라톤 대회에 사람들이 대회 참가를 신청하고 달리기 시간을 기록할 수 있도록 클라우드상에 백엔드 시스템를 구축 하는 것입니다.

## 요구사항
- 기능 요구사항
  ```
  - 개인 사용자와 대회주최자는 로그인 기능을 통해 토큰을 발급받을 수 있습니다.
  - 인증된 개인 사용자는 자신의 비공식 기록을 입력 및 조회할 수 있습니다.
  - 인증된 개인 사용자는 특정 대회에 참가 신청을 할 수 있습니다.
  - 대회 주최자는 대회 참가자를 조회할 수 있습니다.
  - 대회 주최자는 대회 참가자들에 대한 공식 기록을 입력 및 조회할 수 있습니다.
  - 대회 주최자에 의해 입력된 공식 기록에 따라 해당 참가자의 point 데이터에 점수가 추가됩니다.
  - 개인 사용자는 점수를 확인할 수 있습니다.
  ```
- 인프라 요구사항
  ```
  - 시스템 전반에 가용성, 내결함성, 확장성, 보안성이 고려된 서비스들이 포함되어야 합니다.
  - 하나 이상의 컴퓨팅 유닛에 대한 CI/CD 파이프라인이 구성되어야합니다.
  - 유저 데이터를 저장하고 있는 유저 데이터베이스는 다른 데이터베이스와 분리되어있어야 합니다.
  - 기록 데이터를 기반으로 사용자별 점수를 기록하는 시스템은 데이터 유실을 막기 위해 느슨하게 결합되어야합니다.
  - 시스템 메트릭 또는 저장된 데이터에 대한 하나 이상의 시각화된 모니터링 시스템이 구축되어야합니다.
  ```

# 최종 산출물
산출물로는 아키텍쳐 다이어그램, 테라폼, CI / CD, 백엔드 소스가 있습니다.
## 아키텍쳐
![](https://velog.velcdn.com/images/sororiri/post/82bc8f04-164e-4739-a320-d97fc8860ada/image.png)

## 테라폼
AWS 콘솔로 만들었던 인프라 리소스의 대부분을 테라폼 코드로 작성하였습니다.
작성한 테라폼 리소스는 다음과 같습니다.
- VPC 환경 (VPC, 서브넷, 보안그룹)
- ECS 서비스에 필요한 관련 리소스
   - Cluster
   - Service
   - Task Definition
   - ALB
   - 타겟 그룹
   - VPC 엔드포인트

## CI / CD
백엔드 코드가 `릴리즈 브랜치` 에 머지될 때에 도커 이미지를 생성하여 배포될 수 있도록 구성하였습니다.

## 백엔드 소스
인프라 아키텍쳐를 테스트하기 위해 만들어진 비교적 간단한 백엔드 소스입니다.
- 점수 관련 벡엔드 서버
- 대회기록 벡엔드 서버
- 유저정보 벡엔드 서버

# **Environment**  
|                | Description      |
|----------------|------------------|
| OS             | Ubuntu 22.04     |
| Language       | Typescript       |
| DB             | DynamoDB, MySQL  |
| Framework      | Express, Node.JS |
| Cloud Provider | AWS              |
| CI             | Git-Action       |
| IaC            | Terraform        |
 
# 설치 방법
테라폼을 통한 AWS 인프라 프로비져닝과 백엔드 코드의 도커 이미지 빌드를 진행할 수 있습니다.
## 테라폼을 통한 프로젝트의 AWS 리소스 프로비져닝
> 선수 조건:
[테라폼 설치](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 및 
[AWS CLI 자격 증명](https://docs.aws.amazon.com/ko_kr/serverless-application-model/latest/developerguide/prerequisites.html#prerequisites-configure-credentials)

1. 프로젝트 레포 획득 및 테라폼 폴더 이동
```bash
$ git clone https://github.com/SangYunLeee/marathon-infra.git
$ cd marathon-infra.git/terraform
```
2. 테라폼 리소스 생성
테라폼을 통해 AWS 리소스를 생성한다.
```
$ terraform init
$ terraform plan
$ terraform apply
```
## 백엔드 서버의 도커 이미지화 및 실행 (record 백엔드 기준)
1. 프로젝트 레포 획득 및 백엔드 폴더 이동
```bash
$ git clone https://github.com/SangYunLeee/marathon-infra.git
$ cd /marathon-infra.git/backend/race-backend
```
2. 도커 이미지 생성
```bash
docker build -t race-record .
```
3. 도커 이미지 실행
```bash
docker run -p 5500:5500 race-record
```
  - user 백엔드 : [release/ecs-race-user](https://github.com/cs-devops-bootcamp/devops-04-Final-Team3/tree/release/ecs-race-user)
  - point 백엔드 : [release/ecs-race-point](https://github.com/cs-devops-bootcamp/devops-04-Final-Team3/tree/release/ecs-race-point)
  - record 백엔드 : [release/ecs-race-record](https://github.com/cs-devops-bootcamp/devops-04-Final-Team3/tree/release/ecs-race-record)


