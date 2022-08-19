# BookFinder


# 목차
  1. [Developer](#Developer)
  2. [프로젝트 소개](#프로젝트-소개)
     1. [기능 소개](#기능-소개)
  3. [회고](회고)
  
---


# 👨‍💻 Developer
|Peppo|
|:--:|
|[<img src = "https://user-images.githubusercontent.com/78457093/180595896-1ae6c1a5-4ebe-48da-9d7d-8246046ec12e.jpg" width = "250" height = "300">](https://github.com/Bhoon-coding)|

--- 
<br>

# 프로젝트 소개
- 오픈 API ([Google Book](https://developers.google.com/books/docs/overview?hl=en))를 이용하여 책 검색어에 대한 데이터를 받아와 나타냄.

<br>


## 기능 소개

- `MVVM 아키텍처` 사용
- `infinite scroll` (무한스크롤) 구현
- 리스트에서 책을 터치하면 `상세페이지를 webView`로 띄움.
- 데이터 호출 되는동안 `로딩 애니메이션` 
- `UnitTest`
- 이미지 캐싱

### BookListPage
|검색, 무한스크롤, <br>오픈API (GET)|
|:--:|
|<img src = "https://user-images.githubusercontent.com/64088377/185276557-fa516846-9a89-47c3-bd43-797b05f9d82a.gif" width = "200">|

<br>

### BookDetailPage
|상세페이지 (WebView)|
|:--:|
|<img src = "https://i.imgur.com/RZfHSqV.gif" width = "200"> |

---
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

---
# 회고

이번 프로젝트로 정말 많은걸 배웠다.
MVVM도 학습해서 적용해보았으며, UnitTest도 해볼 수 있었던 좋은 경험이었다.
이전 프로젝트와는 다른방식으로 무한스크롤(infiniteScroll)도 구현해보았고 짧았지만 여러가지로 많은 경험을 할 수 있었던 것 같아 너무 좋았다.
먼저 피드백 받은것을 반영해보고 고도화 시켜봐야겠다. 


