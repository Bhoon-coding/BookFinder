# BookFinder


# 목차
  1. [Developer](#Developer)
  2. [프로젝트 소개](#프로젝트-소개)
     1. [기능 소개](#기능-소개)
  3. [객체 역할 소개](#객체-역할-소개)
  - 앱 설계
  - View
  - Manager
  4. [고민한점](#고민한점) 
  5. [회고](#회고)
  
---


# 👨‍💻 Developer
|Peppo|
|:--:|
|[<img src = "https://user-images.githubusercontent.com/78457093/180595896-1ae6c1a5-4ebe-48da-9d7d-8246046ec12e.jpg" width = "250" height = "300">](https://github.com/Bhoon-coding)|

--- 
<br>

# 프로젝트 소개
- 오픈 API ([Google Book](https://developers.google.com/books/docs/overview?hl=en))를 이용하여 책 검색어에 대한 데이터를 받아와 나타냄.

### API 예시

```swift 
totalItems: 878
  ▿ items: 10 elements
    ▿ BookFinder.BookList
      - id: "PIVQ6PANsikC"
      ▿ bookInfo: BookFinder.BookInfo
        - title: "American Red Cross Sports Safety Training Im"
        ▿ authors: Optional(["Granada Learning Limited"])
          ▿ some: 1 element
            - "Granada Learning Limited"
        ▿ publishedDate: Optional("1997-12")
          - some: "1997-12"
        ▿ imageLinks: Optional(BookFinder.BookImage(thumbnail: "http://books.google.com/books/content?id=PIVQ6PANsikC&printsec=frontcover&img=1&zoom=1&source=gbs_api"))
          ▿ some: BookFinder.BookImage
            - thumbnail: "http://books.google.com/books/content?id=PIVQ6PANsikC&printsec=frontcover&img=1&zoom=1&source=gbs_api"
        - infoLink: "http://books.google.co.kr/books?id=PIVQ6PANsikC&dq=Red&hl=&source=gbs_api"
```

<br>


## 기능 소개

- `MVVM 아키텍처` 사용
- `infinite scroll` (무한스크롤) 구현
- 리스트에서 책을 터치하면 `상세페이지를 webView`로 띄움.
- 데이터 호출 되는동안 `로딩 애니메이션` 
- `UnitTest`
- 이미지 캐싱

<br>

### BookListPage
|검색, 무한스크롤, <br>오픈API (GET)|상세페이지 (WebView)|
|:--:|:--:|
|<img src = "https://user-images.githubusercontent.com/64088377/187182069-0d0d1a6d-d67e-40a2-b4f1-1e048e6a0514.gif" width = "200">|<img src = "https://i.imgur.com/RZfHSqV.gif" width = "200"> |

<br>

<!-- # 고민한 부분

### 문제1

별표 버튼을 누를때마다 전체 컬렉션뷰 내부 전체 cell에 입력이 되는 상황
cell에 있는 별표 버튼을 index에 맞게 각각 눌리게 구현해야 했었음.

### 해결

cell 내부에서 `CellActionDelegate` 를 만들어준 후,
PhotoListVC에서 채택하여 `starButtonTapped` 메서드의 파라미터로`PhotoListCollectionViewCell`을 적용 -> collectionView.indexPath(for: cell)로 눌려지는 Index 파악

```swift
// PhotoListCollectionViewCell
protocol CellActionDelegate: AnyObject {
    
    func starButtonTapped(cell: PhotoListCollectionViewCell) { }
    
    
}

class PhotoListCollectionViewCell: UICollectionViewCell { 
    
    weak var cellDelegate: CellActionDelegate?

    //...
    
    @objc func starTapped() {
        cellDelegate?.starButtonTapped(cell: self)
    }
    
}
```

```swift
// PhotoListViewController
func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell { 
    // ... 
    
    cell.cellDelegate = self
    
}

extension PhotoListViewController: CellActionDelegate {
    
    func starButtonTapped(cell: PhotoListCollectionViewCell) {
     guard let indexPath = collectionView.indexPath(for: cell) else { return }       
    // ...
    }
}
```

### 문제2
CollectionViewCell에서 cornerRadius를 지정해도 반응이 없음.

### 해결

`clipsToBounds = true` 를 이용해 해결

```swift
clipsToBounds = true // subView가 view의 경계를 넘어갈 시 잘림.
clipsToBounds = false // 경계를 넘어가도 잘리지 않음
```

### 배운점

subView에 아무리 cornerRadius를 줘봤자 상위 view에서 설정이 되어있지 않으면 반응이없다.
 -->


<br>

# 객체 역할 소개

### 앱 설계

<img src = "https://i.imgur.com/q7AG67F.png" width = "800">

### View 관련

| class / struct               | 역할                                                         |
| ---------------------------- | ----------------------------------------------------------- |
| `SearchBookCollectionViewCell`        | - BookList 데이터를 표시하는 Cell |
| `SearchBookViewController`   | - `SearchController`를 사용하여 검색기능 사용가능 <br />- 키워드 입력 후 `검색`을 누르면 GET 메서드로 데이터를 불러옴 <br />- BookList의 item(cell)을 누르면 `BookDetailViewController`로 이동 <br /> - `BookDetailViewController` 선택된 item의 데이터 전달 |
| `BookDetailViewController`     | - `SearchBookViewController`에서 전달받은 데이터를 `webView`로 표현 <br />- load가 되기 전까진 `로딩 인디케이터` 표현  |
### Manger 관련

| class / struct               | 역할                                                         |
| ---------------------------- | ----------------------------------------------------------- |
| `EndPointType`               | - URLRequest를 반환하는데 필요한 정보를 정의하는 Protocol |
| `BookListEndPoint`             | - EndPointType채택, URLRequest를 반환하는데 필요한 정보를 담고있는 객체 |
| `NetworkRequester`           | - EndPointType 혹은 URLString를 매개변수로 전달받아, 통신을 수행하는 객체 |
| `BookListAPIProvider`          | - BookListEndPoint, NetworkRequester를 사용하여 API통신을 수행하는 객체 <br />- 반환된 data를 Decode함.|
| `BookImageProvider`       | - 이미지의 URL -> Image data를 얻어오는 객체. <br />- image caching기능을 수행. |


---
# 고민한점

### 문제

검색결과가 없을때 로딩 인디케이터 (spinner)가 계속 돌아감

### 원인

아래와 같이 JSON 의 키 값중 items가 데이터가 없는경우에 해당 값이 없음.

**검색결과가 없을때** <br>
<img src = "https://user-images.githubusercontent.com/64088377/186690514-d6f099dd-c9a4-4623-b6cc-487444d0d839.png" width = "300">

<br>

**검색결과가 있을때** <br>
<img src = "https://user-images.githubusercontent.com/64088377/186690572-43981de6-fa75-4d87-8486-f5a2c4c0dfcd.png" width = "600">


### 해결

`BookListResults` 의 items에 Optional 처리를 해주었고,  

```swift
struct BookListResults: Decodable {
    
    let totalItems: Int
    let items: [BookList]?  // Optional
    
}
```

items가 없을시 옵셔널 바인딩 (guard let) 에서 예외처리 부분에 코드를 추가해줌.
```swift
// SearchBookViewModel
    func fetchBookList(
        with searchText: String
    ) {
        isLoading.value = true
        bookListAPIProvider.fetchBooks(
            with: searchText,
            from: startIndex.value,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let data):
                    guard let items = data.items else {
                        self.noResult.value = true // 예외 처리
                        return
                    }
                    self.searchedBookTotalCount.value = data.totalItems
                    self.bookList.value = items
                    self.startIndex.value += 10
                    self.searchedTitle.value = searchText
                    self.isLoading.value = false
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoading.value = false
                }
            })
    }
```
+추가로 

검색결과가 없다는걸 사용자가 알 수 있게 Alert 띄워줌

<img src = "https://user-images.githubusercontent.com/64088377/186696242-fb795850-1f98-4bf4-8fce-c5637578b2df.png" width = "200">


----




# 회고

이번 프로젝트로 정말 많은걸 배웠다.
MVVM도 학습해서 적용해보았으며, UnitTest도 해볼 수 있었던 좋은 경험이었다.
이전 프로젝트와는 다른방식으로 무한스크롤(infiniteScroll)도 구현해보았고 짧았지만 여러가지로 많은 경험을 할 수 있었던 것 같아 너무 좋았다.
먼저 피드백 받은것을 반영해보고 고도화 시켜봐야겠다. 


