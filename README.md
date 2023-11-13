# AWS 를 활용한 인프라 구성 프로젝트
**팀원:** 이상윤 / 김민주 / 김한수 / 문한성

**기간:** 2023.06.12~2022.06.30

## 간략한 설명
AWS 클라우드 인프라를 구축하는 프로젝트입니다. 주제는 마라톤 대회 기록 시스템으로,
마라톤 대회에 사람들이 대회 참가를 신청하고 달리기 시간을 기록할 수 있도록 클라우드상에 백엔드 시스템를 구축 하는 것을 목표로 하였습니다.

# 최종 산출물
산출물로는 아키텍쳐 다이어그램, 테라폼, CI / CD, 백엔드 소스가 있습니다.
## 아키텍쳐
![image](https://github.com/SangYunLeee/marathon-infra/assets/35091494/6af8bef4-d878-41ce-9135-b045c8e7a30f)

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


