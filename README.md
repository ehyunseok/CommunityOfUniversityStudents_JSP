# BookFriends_JSP

## 소개
**BookFriends**는 독서가들이 이용할 수 있는 웹사이트입니다. 서평 공유, 독서 모임 모집, 기타 자유게시판, 실시간 채팅, 도서관 검색, 중고 도서 거레/교환

## 목차
- [소개](#소개)
- [개발환경](#개발환경)
- [주요 기능](#주요-기능)
- [ERD](#ERD)
- [프로젝트 설정](#프로젝트-설정)
- [업데이트 로그](#업데이트-로그)


## 개발환경
- **Frontend**: HTML, CSS, JavaScript
- **Backend**: JDK 17, JSP
- **IDE**: Eclipse
- **Database**: MySQL
- **Server**: Apache Tomcat 9.0
- **Libraries**:
  - jQuery 3.7.1
  - Bootstrap 4.6.2
  - Popper 1.16.1
  - Java Mail 1.4.7
  - Java Activation Framework 1.1.1
  - Apache Commons Lang 3.14.0
  - Apache Commons Text 1.12.0
  - Apache Commons FileUpload 1.5
  - Apache Commons io 2.16.1
  - Javax Servlet JSP API 2.3.3
  - Javax Servlet API 4.0.1
  - Jason Core 2.13.0
  - Json 20231013
  - Json Factory 1.0.2
  - Json Generator 0.5
  - Jsoup 1.17.2
  - MySQL Connector J 8.0.33

## 주요 기능
### 사용자 관리
- **회원가입**: 이메일 인증 기능 포함
- **로그인/로그아웃**: 사용자 인증 및 세션 관리

### 서평
- **등록**: 도서에 대한 평가 등록
- **수정 & 삭제**: 사용자에 의한 서평 수정 및 삭제
- **추천**: 서평 추천 기능 (중복 추천 방지)
- **조회**: 도서구분별 조회, 최신순/추천순 조회

### 자유게시판
- **등록**: 게시글 등록
- **수정 & 삭제**: 작성자만 게시글 수정 및 삭제 가능
- **추천**: 게시글 추천 기능 (중복 추천 방지)
- **조회**: 카테고리별 조회, 최신순/추천순/조회수순 조회

### 신고
- **이메일 전송**: 부적절한 콘텐츠 신고 시 관리자에게 이메일 전송

### 검색
- **검색 기능**: 강의 평가, 게시글 등 검색

### 댓글
- **등록**: 댓글 등록
- **수정 & 삭제**: 작성자만 댓글 수정 및 삭제 가능
- **추천**: 댓글 추천 기능 (중복 추천 방지)

### 미완성 기능 (추후 구현 예정)
- **채팅**: 실시간 채팅 기능
- **도서관 검색**: 국립중앙도서관 api 이용
- **중고 도서 거래**
- **게시판 카테고리 수정**

## ERD
#### Entity-Relationship Diagram
![image](https://github.com/ehyunseok/CommunityOfUniversityStudents_JSP/assets/121013391/87f11134-778e-428f-86fe-4c0c865d450a)


## 프로젝트 설정
### 환경 설정
1. **Eclipse 설치 및 설정**: JSP와 서블릿 개발을 위한 Eclipse IDE 설정
2. **Apache Tomcat 설치**: 웹 서버로 Apache Tomcat 9.0 설정
3. **MySQL 설치**: 데이터베이스 설정 및 초기화
4. **라이브러리 설치**: 라이브러리 설치 및 설정

### 데이터베이스 설정
1. MySQL 데이터베이스 생성
2. 필요한 테이블 생성 및 초기 데이터 입력 (스키마 및 데이터 정의서 참고)


## 업데이트 로그
- 2024.05.25
  - 사용자 입력 부분 XSS 방지
  - 사용자 비밀번호 암호화
  - 회원가입 아이디 중복 확인 기능 추가
- 2024.05.26
  - 프로젝트 주제 변환 - 재학생 커뮤니티 -> 독서 커뮤니티
  - 서평 메인/서평상세페이지 ui, 서평 등록/수정/삭제 구현
  - 독서모임 메인 ui
  - 자유게시판 상세페이지 댓글 리스트 수정
- 2024.05.28
  - 독서모임 모집글 작성, 수정(Quill 에디터 적용), 삭제 구현
  - CSP 보안 적용(독서모임)
