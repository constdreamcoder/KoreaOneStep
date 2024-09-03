# Korea One Step - 대한민국 한걸음

<p align="center">
  <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/9fec29e3-2b03-4ea8-98cc-f52f0668098d" align="center" width="100%">
</p>

<br/>

## 대한민국 한걸음

- 서비스 소개: 몸이 불편하신 분들을 위한 여행 정보 제공 앱
- 개발 인원: 1인
- 개발 기간: 24.03.08 ~ 24.03.21(총 14일)
- 개발 환경
    - 최소버전: iOS 15
    - Portrait Orientation 지원
    - 라이트 모드 지원
- 링크
    - [피그마](https://www.figma.com/design/xJLsWTQgokQMhk37MntPfK/Untitled?node-id=0-1&t=eAtZYq7cNsf28U9Z-1)
    - [앱 스토어](https://apps.apple.com/kr/app/%EB%8C%80%ED%95%9C%EB%AF%BC%EA%B5%AD-%ED%95%9C%EA%B1%B8%EC%9D%8C-korea-one-step/id6479728845)

<br/>

## 🗓️ 업데이트 히스토리

### RxSwift로 리팩토링
- 기간: 24.08.16 ~ **(진행중)**

<br/>

## 💪 주요 기능

- 주변 여행지 검색 기능
    - 유저 현재 위치 기반 거리별, 제목별, 수정일순별, 생성일순별, 카테고리별 검색 가능
- 지역별 여행지 검색 기능
- 여행지별 무장애 정보 조회 기능
    - 몸이 불편하신 분들이 여행지에서 도움받을 수 있는 공공서비스 조회 가능
- 여행지 북마크 기능

<br/>

## 🛠 기술 소개

- UIKit, SnapKit, Custom Observable
- MVVM, Input/Output, Singleton
- Alamofire, Kingfisher, Realm
- 프로토콜를 이용한 UI 규격화, Accordion UI
- Floating Panel, TTGTags, Toast
- Firebase Crashlytics, Firebase Analytics

<br/>

## 💻 기술 적용
- **Custom Obervable** 구성을 기반으로 반응형 **MVVM Input/Ouput** 패턴 구성
- **TableView**를 활용한 **Accordion UI** 구성
- **Enum**을 통한 API 호출의 **Endpoint** 중앙화 관리
- **Protocol** 명세 기반 코드 베이스 UI 구성
- **Toast** 라이브러리를 통한 네트워크 상태 메세지 표시
- **Firebase Analytics**과 **Firebase Crashlytics** 구성을 통한 앱의 성능 모니터링과 안정성 향상
- **ATS** 설정을 통한 공공데이터 API HTTP 통신 대응

<br/>

## 💾 구현 내용

### 1. TableView를 활용한 Accordion UI

|<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/f0cf00c0-1192-44a2-bb69-082f9f613f26" align="center" width="200">|<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/9c698058-e8a5-477c-a0f2-bc028e543008" align="center" width="200">|
  |--|--|
  |||

- 구현 과정
    - 열거형을 통하여 TableView의 전체적인 구조 구성
      <details>
      <summary><b>코드</b></summary>
      <div markdown="1">

      ```swift
      enum DetailTableViewSection: Int, CaseIterable {
        case descriptionSection = 0
        case serviceDetailSection = 1

        enum DescriptionSection: CaseIterable {
          case regionDetailCell
          case phoneNumberCell
          case addressCell
          case serviceProvidedCell
        }

        enum ServiceDetailSection: CaseIterable {
          case physicalDisability
          case visualImpairment
          case hearingImpairment
          case familiesWithInfantsAndToddlers
          case elderlyPeople
          
          var providedServiceNumber: Int {
              switch self {
              case .physicalDisability:
                  return PhysicalDisability.allCases.count
              case .visualImpairment:
                  return VisualImpairment.allCases.count
              case .hearingImpairment:
                  return HearingImpairment.allCases.count
              case .familiesWithInfantsAndToddlers:
                  return FamiliesWithInfantsAndToddlers.allCases.count
              case .elderlyPeople:
                  return ElderlyPeople.allCases.count
              }
          }
          
          var serviceImage: UIImage {
              switch self {
              case .physicalDisability:
                  return UIImage.physicalDisability
              case .visualImpairment:
                  return UIImage.visualImpairment
              case .hearingImpairment:
                  return UIImage.hearingImpairment
              case .familiesWithInfantsAndToddlers:
                  return UIImage.familiesWithInfantsAndToddlers
              case .elderlyPeople:
                  return UIImage.elderlyPeople
              }
          }
          
          var serviceTitleList: [String] {
              switch self {
              case .physicalDisability:
                  return PhysicalDisability.allCases.map { $0.rawValue }
              case .visualImpairment:
                  return VisualImpairment.allCases.map { $0.rawValue }
              case .hearingImpairment:
                  return HearingImpairment.allCases.map { $0.rawValue }
              case .familiesWithInfantsAndToddlers:
                  return FamiliesWithInfantsAndToddlers.allCases.map { $0.rawValue }
              case .elderlyPeople:
                  return ElderlyPeople.allCases.map { $0.rawValue }
              }
          }
          
          enum PhysicalDisability: String, CaseIterable {
              case parkingStatus = "주차여부"
              case publicTransport = "대중교통"
              case coreMovementLine = "핵심동선"
              case ticketBox = "매표소"
              case promotionalMaterial = "홍보물"
              case wheelchair = "휠체어"
              case elevator = "엘리베이터"
              case restroom = "화장실"
              case seat = "관람석(좌석)"
          }
          
          enum VisualImpairment: String, CaseIterable {
              case bailieBlock = "점자블록"
              case guide = "안내요원"
              case audioGuidance = "음성안내"
              case LargePrintOrBraillePromotionalMaterials = "큰활자/점자 홍보물"
              case brailleSign = "점자표지판"
              case guidanceFacility = "유도안내설비"
          }
          
          enum HearingImpairment: String, CaseIterable {
              case signLanguageGuidance = "수어안내"
              case subtitle = "자막"
          }
          
          enum FamiliesWithInfantsAndToddlers: String, CaseIterable {
              case strollerRent = "유아차 대여"
          }
          
          enum ElderlyPeople: String, CaseIterable {
              case wheelChairRent = "휠체어 대여"
              case mobilityAidsRent = "이동보조도구 대여"
          }
        }
      }
      ```

      </div>
      </details>
    - TableView Cell에 사용할 Cell 모델 정의
      <details>
      <summary><b>코드</b></summary>
      <div markdown="1">

      ```swift
      // Cell 정의
      struct cellData {
        var opened: Bool // 하위 항목이 열렸는지에 대한 상태값 저장
        var sectionData: [String] // Cell에 표시될 데이터 저장
      }
      ```

      </div>
      </details>
  - TableView에서 필요한 항목만큼 Section 생성
      <details>
      <summary><b>코드</b></summary>
      <div markdown="1">

      ```swift
      // 필요 항목수만큼 Section 생성
      func numberOfSections(in tableView: UITableView) -> Int {
          return DetailTableViewSection.allCases.count - 1 + selectedService.providedServiceNumber
      }
      ```

      </div>
      </details>
  - TableView Section의 하위항목 open 여부에 따라 Section 하위 항목수만큼 Cell 생성
      <details>
      <summary><b>코드</b></summary>
      <div markdown="1">

      ```swift
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if section == DetailTableViewSection.descriptionSection.rawValue {
            // ...
          } else {
              // TableView Section의 하위항목 open 여부에 따라 Section 하위 항목수만큼 Cell 생성하고
              // 그렇지 않으면 해당 Section 항목만 생성
              if tableViewData[section - 1].opened {
                  return tableViewData[section - 1].sectionData.count + 1
              } else {
                  return 1
              }
          }
      }

      // TableViewCell 정의
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == DetailTableViewSection.descriptionSection.rawValue {
            // ...
        } else {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceProvidedDetailTableViewCell.identifier, for: indexPath) as? ServiceProvidedDetailTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                
                // 선택된 항목 제목 표시
                cell.serviceTitleLabel.text = selectedService.serviceTitleList[indexPath.section - 1]
                
                // 하위 항목 open 여부에 따른 이미지 변경
                if tableViewData[indexPath.section - 1].opened {
                    cell.chevronImageView.image = UIImage(systemName: "chevron.up")
                } else {
                    cell.chevronImageView.image = UIImage(systemName: "chevron.down")
                }
                return cell
            } else {
                // 하위 항목 Cell 정의
                guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier) else { return UITableViewCell() }
                let providedImpairmentAidServiceDescription = tableViewData[indexPath.section - 1].sectionData[indexPath.row - 1]
                cell.textLabel?.text = providedImpairmentAidServiceDescription == "" ? "없음" : providedImpairmentAidServiceDescription
                cell.textLabel?.numberOfLines = 0
                return cell
            }
        }
        return UITableViewCell()
      }
      ```

      </div>
      </details>
  - Section을 선택하면 Cell 모델의 opened 값이 true가 되고, 이때 해당 Section을 reload로 갱신시켜줌으로써 하위 항목들 open
      <details>
      <summary><b>코드</b></summary>
      <div markdown="1">

      ```swift
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          if indexPath.section == DetailTableViewSection.descriptionSection.rawValue {
            // ...
          } else {
              tableView.deselectRow(at: indexPath, animated: true)
              
              if indexPath.row == 0 {
                  // Cell 모델에 정의되어 있는 opened 값을 반전
                  tableViewData[indexPath.section - 1].opened = !tableViewData[indexPath.section - 1].opened
                  
                  // 선택된 Section 갱신
                  tableView.reloadSections([indexPath.section], with: .none)
                
                  // 선택된 Section의 하위 항목중 가장 마지막 항목으로 Scroll
                  if indexPath.section == selectedService.providedServiceNumber && tableViewData[selectedService.providedServiceNumber - 1].opened {
                      tableView.scrollToRow(at: IndexPath(row: 1, section: selectedService.providedServiceNumber), at: .bottom, animated: true)
                  }
              }
          }
      }
      ```

      </div>
      </details>
      
> 관련 Blog [**TableView Cell로 아코디언 형식 만들기**](https://picelworld.tistory.com/3)

### 2. Custom Observable 구성을 통한 반응형 MVVM 패턴 구성

<details>
<summary><b>Custom Observable</b></summary>
<div markdown="1">

```swift
import Foundation

final class Observable<T> {
    
    private var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
}
```

</div>
</details>

### 3. 열거형을 통한 API 호출의 Endpoint 중앙화 관리

<details>
<summary><b>Endpoint 관리 중앙화</b></summary>
<div markdown="1">

```swift
enum KoreaTravelingAPI {
    //...
    
    case providedImpairmentAidServices(contentId: String)
    case touristDestionationCommonInformation(
        contentId: String,
        contentTypeId: String
    )
    case locationBasedTourismInformation(
        latitude: Double,
        longitude: Double,
        radius: Int,
        arrange: String,
        contentTypeId: String
    )
    case areaCode(areaCode: String)
    case keywordBasedSearching(
        keyword: String,
        areaCode: String,
        sigunguCode: String
    )
    
    // Base URL 정의
    var baseURL: String {
        return baseURL
    }
    
    // EndPoint 정의
    var endpoint: String {
        switch self {
        case .providedImpairmentAidServices:
            return "\(baseURL)/detailWithTour1"
        case .touristDestionationCommonInformation:
            return "\(baseURL)/detailCommon1"
        case .locationBasedTourismInformation:
            return "\(baseURL)/locationBasedList1"
        case .areaCode:
            return "\(baseURL)/areaCode1"
        case .keywordBasedSearching:
            return "\(baseURL)/searchKeyword1"
        }
    }
    
    // HTTP Method 정의
    var method: HTTPMethod {
        return .get
    }
    
    // 파라미터 정의
    var parameters: [String: String] {
        switch self {
        case .providedImpairmentAidServices(let contentId):
            return [
                "serviceKey": APIKeys.serviceKey, // 필수, 인증키(서비스키)
                "numOfRows": "30", // 한페이지결과수
                "pageNo": "1", // 페이지번호
                "MobileOS": "IOS", // OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
                "MobileApp": "AppTest", // 필수, 서비스명(어플명)
                "contentId": contentId, // 필수, 콘텐츠ID
                "_type": "json" // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
            ]
        case .touristDestionationCommonInformation(let contentId, let contentTypeId):
            return [
                "serviceKey": APIKeys.serviceKey, // 필수, 인증키(서비스키)
                "numOfRows": "30", // 한페이지결과수
                "pageNo": "1", // 페이지번호
                "MobileOS": "IOS", // 필수, OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
                "MobileApp": "AppTest", // 필수, 서비스명(어플명)
                "contentId": contentId, // 필수, 콘텐츠ID
                "defaultYN": "Y", // 기본정보조회여부( Y,N )
                "firstImageYN": "Y", // 원본, 썸네일대표 이미지, 이미지 공공누리유형정보 조회여부( Y,N )
                "areacodeYN": "Y", // 지역코드, 시군구코드조회여부( Y,N )
                "catcodeYN": "Y", // 대,중,소분류코드조회여부( Y,N )
                "addrinfoYN": "Y", // 주소, 상세주소조회여부( Y,N )
                "mapinfoYN": "Y", // 좌표X, Y 조회여부( Y,N )
                "overviewYN": "Y", // 콘텐츠개요조회여부( Y,N )
                "_type": "json", // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
                "contentTypeId": contentTypeId // 관광타입(관광지, 숙박 등) ID
            ]
        case .locationBasedTourismInformation(let latitude, let longitude, let radius, let arrange, let contentTypeId):
            return [
                "serviceKey": APIKeys.serviceKey, // 인증키
                "numOfRows": "30", // 한페이지 결과수
                "pageNo": "1", // 페이지 번호
                "MobileOS": "IOS", // 필수, OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
                "MobileApp": "AppTest", // 필수, 서비스명(어플명)
                "listYN": "Y", // 목록구분(Y=목록, N=개수)
                "arrange": arrange, // 정렬구분(A=제목순, C=수정일순, D=생성일순, E=거리순) 대표이미지가반드시있는정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순)
                "mapX": "\(longitude)", // 필수, GPS X좌표(WGS84 경도좌표)
                "mapY": "\(latitude)", // 필수, GPS Y좌표(WGS84 위도좌표)
                "radius": "\(radius)", // 필수, 거리반경(단위:m) , Max값 20000m=20Km
                "_type": "json", // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
                "contentTypeId": contentTypeId // 관광타입(12:관광지, 14:문화시설, 15:축제공연행사, 25:여행코스, 28:레포츠, 32:숙박, 38:쇼핑, 39:음식점) ID
            ]
        case .areaCode(let areaCode):
            return [
                "serviceKey": APIKeys.serviceKey, // 필수, 인증키(서비스키)
                "numOfRows": "500", // 한페이지 결과수
                "pageNo": "1", // 페이지 번호
                "MobileOS": "IOS", // 필수, OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
                "MobileApp": "AppTest", // 필수, 서비스명(어플명)
                "_type": "json", // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
                "areaCode": areaCode // 지역코드
            ]
        case .keywordBasedSearching(let keyword, let areaCode, let sigunguCode):
            return [
                "serviceKey": APIKeys.serviceKey, // 필수, 인증키(서비스키)
                "numOfRows": "300", // 한페이지 결과수
                "pageNo": "1", // 페이지 번호
                "MobileOS": "IOS", // 필수, OS 구분 : IOS (아이폰), AND (안드로이드), WIN (윈도우폰), ETC(기타)
                "MobileApp": "AppTest", // 필수, 서비스명(어플명)
                "listYN": "Y", // 목록구분(Y=목록, N=개수)
                "arrange": "O", // 정렬구분(A=제목순, C=수정일순, D=생성일순)대표이미지가반드시있는정렬(O=제목순, Q=수정일순, R=생성일순)
                "keyword": keyword, // 검색요청할키워드(국문=인코딩필요)
                "_type": "json", // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
                "areaCode": areaCode, // 지역코드
                "sigunguCode": sigunguCode // 시군구 코드(지역코드 필수)
            ]
        }
    }
}
```

</div>
</details>

<br/>

## 🔥 트러블 슈팅

### 1. App Transport Security 오류 대응

문제상황

- 공공데이터로 네트워크 통신 중 아래와 같은 오류 발생

  `sessionTaskFailed(error: Error Domain=NSURLErrorDomain Code=-1200 "An SSL error has occurred and a secure connection to the server cannot be made."` 

문제 원인 파악

- 공공데이터의 통신규약이 Apple에서 기본적으로 권장하는 네트워크 통신 규약인 HTTPS가 아닌 HTTP로 이루어 졌었기 때문

해결방법

- Info.plist에서 통신 도메인 주소에 대해 ATS 도메인 예외 처리

<img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/0c7d88f1-bbd7-409d-bfef-8bf789198bfa" align="center" width="100%">

<br/>

> 관련 Blog [**ATS에 대하여**](https://picelworld.tistory.com/4)

### 2. Firebase Analytics 오류 대응 

문제상황

- 앱 사용성에 대한 실시간 분석을 위해 Firebase Analytics를 구성하였지만 프로젝트 실행시 미작동

문제 원인 파악

- Xcode의 앱 Project의 Building Settings 탭에서 Other Linker Flags 항목에 `-ObjC` 플래그를 추가하지 않아 문제 발생

해결방법

- [Firebase 공식 Github README.md](https://github.com/firebase/firebase-ios-sdk/blob/main/SwiftPackageManager.md)에 요구한 것처럼 Other Linker Flags 항목에 `-ObjC` 플래그 추가

### 3. AppStore 배포 후, 리젝 대응

문제상황

- 앱을 AppStore에 배포 후, 리젝 발생

문제 원인 파악

- ‘**유저의 권한 거부 상황에 대한 미흡한 대응**’과 ‘**상세하지 않은 권한 요청 문구 작성**’으로 인한 리젝
  <details>
  <summary><b>리젝 사유</b></summary>
  <div markdown="1">

    - 유저의 권한 거부에 대한 미흡한 대응으로 인한 리젝
              
      <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/201fdd8a-fa7d-403d-ac89-46d5901e555c" align="center" width="100%">  
        
    - 상세하지 않은 권한 문구에 대한 리젝
        
      <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/723e46a9-ac83-4048-ab9a-db914fe70c00" align="center" width="100%">       
  
  </div>
  </details>

해결방법

- 각각의 리젝 사유에 대한 대응후 재심사 요청

  <details>
  <summary><b>리젝 사유 해결</b></summary>
  <div markdown="1">

  - 유저의 권한 거부에 대한 미흡한 대응으로 인한 리젝
    
    <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/7e449ab6-5e4a-4b56-9267-204ffdfe0e85" align="center" width="100%">
    
  - 상세하지 않은 권한 문구에 대한 리젝
    
    <img src="https://github.com/constdreamcoder/SwiftPrac/assets/95998675/bc6bb4d6-6a94-4ff6-8904-ef7babb263c6" align="center" width="100%">
  
  </div>
  </details>

<br/>

## 📚 회고

### 1. 누락된 기능들

- 제한된 기간 내 개발로 인해 초기 기획했었던 일부 기능들의 누락

### 2. 테스트 코드

- 출시전 테스트 코드 미작성으로 인한 앱 정상적 동작 미보장

> 관련 Blog [**출시 프로젝트 회고**](https://picelworld.tistory.com/9)
