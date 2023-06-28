# AWS 를 활용한 마라톤 대회 결과 기록 시스템
Team: 김민주 / 김한수 / 문한성 / 이상윤

Duration: 2023.06.12~2022.06.30

## Requirement
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
## Description
- 일단 패스 

## Architecture
![image](https://github.com/cs-devops-bootcamp/devops-04-Final-Team3/assets/35091494/9df3e687-ad29-4cf6-8b27-3b3034a5c5e0)

## **Environment**  
### <div style="display:flex; flex-direction:row;"> OS : <img src="https://img.shields.io/badge/linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" style="vertical-align: middle;">
</div>

### <div style="display:flex; flex-direction:row;"> Backend Language : <img src="https://img.shields.io/badge/javascript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black" style="vertical-align: middle;">
</div>

### <div style="display:flex; flex-direction:row;"> DB : <img src="https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white" style="vertical-align: middle;"> <img src="https://img.shields.io/badge/dynamodb-4053D6?style=for-the-badge&logo=amazondynamodb&logoColor=white" style="vertical-align: middle;">
</div>

### <div style="display:flex; flex-direction:row;"> Framework : <img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" style="vertical-align: middle;"> <img src="https://img.shields.io/badge/Express-000000?style=for-the-badge&logo=express&logoColor=white" style="vertical-align: middle;">
</div>

### <div style="display:flex; flex-direction:row;"> Cloud Provider : <img src="https://img.shields.io/badge/Amazon AWS-232F3E?style=for-the-badge&logo=amazon aws&logoColor=white" style="vertical-align: middle;">
</div>

### <div style="display:flex; flex-direction:row;"> CI/CD : <img src="https://img.shields.io/badge/github actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white" style="vertical-align: middle;">
</div>

### <div style="display:flex; flex-direction:row;"> IaC : <img src="https://img.shields.io/badge/terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=#7B42BC" style="vertical-align: middle;">
</div>
 

## Installation
- 테라폼
> 선수 조건:
[테라폼 설치](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 및 
[AWS CLI 자격 증명](https://docs.aws.amazon.com/ko_kr/serverless-application-model/latest/developerguide/prerequisites.html#prerequisites-configure-credentials)

1. 테라폼 브랜치로 이동
```bash
$ git clone -b release/terraform https://github.com/cs-devops-bootcamp/devops-04-Final-Team3/tree/release/terraform
$ cd devops-04-Final-Team3/terraform
```
2. 테라폼 리소스 생성
테라폼을 통해 AWS 리소스를 생성한다.
```
$ terraform init
$ terraform plan
$ terraform apply
```
- 백엔드 서버 (record 백엔드 기준)
1. record 브랜치로 이동
```bash
$ git clone -b ecs-race-point https://github.com/cs-devops-bootcamp/devops-04-Final-Team3/tree/release/ecs-race-record
$ cd devops-04-Final-Team3/backend/race-backend
```
2. 도커 파일 생성
```bash
docker build -t race-record .
```
3. 도커 파일 실행
```bash
docker run -p 5500:5500 race-record
```
  - user 백엔드 : [release/ecs-race-user](https://github.com/cs-devops-bootcamp/devops-04-Final-Team3/tree/release/ecs-race-user)
  - point 백엔드 : [release/ecs-race-point](https://github.com/cs-devops-bootcamp/devops-04-Final-Team3/tree/release/ecs-race-point)
  - record 백엔드 : [release/ecs-race-record](https://github.com/cs-devops-bootcamp/devops-04-Final-Team3/tree/release/ecs-race-record)


