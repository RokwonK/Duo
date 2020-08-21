# Duo - 게임파티원 구하기 앱 iOS

네아로 = 네이버로그인  
API 이용신청 - 다운로드 URL, URL Scheme(프로젝트의 info에 URL Types에도 입력 후 같은 것을 입력)을 입력

- Pod  
개발을 하면서 외부 라이브러리의 필요성이 있고 의존성 문제에서 꼬이는 경우가 있음.  
이러한 의존성 관리 툴이 ios에서는 CocoaPods(안드로이드에서는 Maven, Gradle)  
    1. 프로젝트 폴더로 가서 pod init => Podfile생성
    2. 라이브러리들 넣고 pod install => 라이브러리들 설치
        - Podfile.lock 생성 : 라이브러리들의 버전 고정을 위한 파일
        - Pods : 라이브러리들이 다운로드 되는 디렉토리
        - 프로젝트이름.xcworkspace : Pods를 사용할 수 있는 워크스페이스(라이브러리들 사용할려면 이걸로 개발해야함)

pod 으로 alamofire, naveridlogin-sdk-ios 설치  
- alamofire =>  
http통신 라이브러리, 기존에 기본 라이브러리를 사용하면 가독성 및 코드 길이(불편함)이 증가, alamofire는 이런 것들을 개선(Swift로 작성된 HTTP 네트워킹 라이브러리)
- naveridlogin-sdk-ios =>  
네이버아이디로 로그인(접근, 갱신 토큰을 주고 받을 수 있는 라이브러리)  
    1. .xcworkspace로 연다음 Pods/Pods/쭉가서/NaverThirdparty~forApp.h
    2. key랑 secret 입력칸에 내 키/값 넣기
    3. info.plist에 인증진행시 사파리나 네이버 앱 접근 허용하게 코드 추가하기
    

- NS  
코코아의 모든 함수 상수 타입 이름에  NS가 앞에 붙는 것을 볼 수 있다.  


