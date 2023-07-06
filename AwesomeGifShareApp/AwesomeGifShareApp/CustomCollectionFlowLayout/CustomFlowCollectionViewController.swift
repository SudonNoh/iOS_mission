//
//  ViewController.swift
//  AwesomeGifShareApp
//
//  Created by Sudon Noh on 2023/06/24.
//

import UIKit
import SnapKit
import Then
import SwiftyGif


class CustomFlowCollectionViewController: UIViewController {
    
    var gifList : [URL] = []{
        didSet {
            DispatchQueue.main.async {
                self.navigationItem.title = "가져온 움짤: \(self.gifList.count)"
            }
        }
    }
    
    /// 선택된 gifList
    var selectedGifList: Set<String> = [] {
        didSet {
            print(#fileID, #function, #line, "- \(selectedGifList.count)")
        }
    }
    
    /// 선택모드
    var isSelectionMode: Bool = false
    var selectionModeInfo: String {
        return isSelectionMode ? "선택모드 OFF":"선택모드 ON"
    }
    
    let collectionViewLayout = UICollectionViewFlowLayout()
    
    lazy var collectionView : UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.dataSource = self
        $0.delegate = self
    }
    
    var pullToRefreshControl: UIRefreshControl = UIRefreshControl().then {
        $0.tintColor = .blue
        $0.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    // 현재 Offset
    var currentOffset: Int = 0
    // 조회 개수
    var fetchLimit: Int = 12
    
    // 더 불러오는 중
    var isFetchingMore: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupUI()
        self.setupCollectionView()
        
        fetchGiphyList(completion: { [weak self] (gifUrlList: [URL]) in
            guard let self = self else { return }
            self.gifList = gifUrlList
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.collectionView.reloadData()
            }
        })
    }
    
    func fetchGiphyList(offset: Int = 0,
                        limit: Int = 3,
                        completion: @escaping ([URL]) -> Void) {
        
        let url = URL(string: Env.giphyURL + "?api_key=" + Env.giphyKEY + "&offset=\(offset)&limit=\(limit)")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, err in
            // weak self
            // 클로저 안에서 self를 사용하게 되면 강한 참조로 되기 때문에
            // 메모리에 문제가 생길 수 있다.
            // 이를 위해 약한 참조로 만들어 주어야 하는데 그 방법이 [weak self]를 해주는 것이다.
            guard let self = self else { return }
            
            if err != nil {

                return
            }
            
            guard let data: Data = data else { return }
            
            guard let giphyResponse = try? JSONDecoder().decode(GiphyResponse.self, from: data),
                  let giphyList: [Giphy] = giphyResponse.data else { return }
            
            print(#fileID, #function, #line, "- \(giphyList.count)")
            
            let urlList: [URL] = giphyList.compactMap { $0.getUrl() }
            print(#fileID, #function, #line, "- \(urlList.count)")
            
            completion(urlList)
        }
        task.resume()
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        
        fetchGiphyList(completion: { [weak self] (gifUrlList: [URL]) in
            guard let self = self else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.gifList = gifUrlList
                self.collectionView.performBatchUpdates({
                    let idxSet = IndexSet(integer: 0)
                    self.collectionView.reloadSections(idxSet)
                }, completion: {_ in
                    sender.endRefreshing()
                })
            }
        })
    }
}

extension CustomFlowCollectionViewController {
    fileprivate func setupUI() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "가져온 움짤"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: self.selectionModeInfo,
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(toggleSelectionMode(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음 가져오기: offset: \(self.currentOffset)",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(fetchMore(_:)))
        
        self.view.addSubview(self.collectionView)
        
        let safeArea = self.view.safeAreaLayoutGuide.snp
        
        self.collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeArea.edges)
        }
    }
    
    @objc fileprivate func toggleSelectionMode(_ sender: UIBarButtonItem) {
        isSelectionMode.toggle()
        sender.title = self.selectionModeInfo
        // reloadData만 할 경우 애니메이션이 나오지 않는다.
        // self.collectionView.reloadData()
        
        // 애니메이션 넣기
        self.collectionView.performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            let indexSet = IndexSet(integer: 0)
            
            self.collectionView.reloadSections(indexSet)
        })
    }
    
    @objc fileprivate func fetchMore(_ sender: UIBarButtonItem) {
        fetchMoreGiphyList()
    }
}

/// setting CollectionView
extension CustomFlowCollectionViewController {
    fileprivate func setupCollectionView() {
        collectionView.register(
            CustomFlowCollectionViewCell.self,
            forCellWithReuseIdentifier: "CustomFlowCollectionViewCell"
        )
        collectionView.register(
            CustomFlowCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "CustomFlowCollectionViewHeader"
        )
        collectionView.register(
            CustomFlowCollectionViewFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "CustomFlowCollectionViewFooter"
        )
        collectionView.refreshControl = pullToRefreshControl
    }
}

extension CustomFlowCollectionViewController: UICollectionViewDelegate {
    
    // 아이템 선택되기 전
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // 아이템이 선택되기 전에 didSeletItemAt이 실행되지 않도록 필터한다.
        return isSelectionMode
    }
    
    // 아이템 선택됨
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedUrlString = gifList[indexPath.item].absoluteString

        if self.selectedGifList.contains(selectedUrlString) {
            self.selectedGifList.remove(selectedUrlString)
        } else {
            self.selectedGifList.insert(selectedUrlString)
        }
        
        collectionView.reloadItems(at: [indexPath])
        
        let headers = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader)
        if let sectionHeader = headers.first(where:  { $0.isKind(of: CustomFlowCollectionViewHeader.self) }) as? CustomFlowCollectionViewHeader {
            sectionHeader.lbl.text = "선택된 움짤 수 : \(selectedGifList.count)"
        }
    }
    
    
}

/// CollectionView DataSource
extension CustomFlowCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gifList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CustomFlowCollectionViewCell",
            for: indexPath) as? CustomFlowCollectionViewCell,
              let cellData : URL = self.getItem(indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(cellData: cellData,
                           isSelectionMode: self.isSelectionMode,
                           selectedGifList: self.selectedGifList)

        return cell
    }
}

/// CollectionView Delegate
extension CustomFlowCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    /// header & footer 설정
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "CustomFlowCollectionViewHeader",
                for: indexPath
            )
        default:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "CustomFlowCollectionViewFooter",
                for: indexPath
            )
        }
    }
    
    /// footer 크기 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = self.collectionView.bounds.width
        return CGSize(width: width, height: 100)
    }
    
    /// header 크기 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = self.collectionView.bounds.width
        
        if isSelectionMode {
            return CGSize(width: width, height: 30)
        }
        return CGSize(width: width, height: 0)
    }
    
    /// 몇 개씩 보여줄 거냐를 설정할 수 있다
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collectionView.bounds.width / 3) - 15
        return CGSize(width: width, height: width)
    }
    
    /// 셀 당 inset을 주는 방법
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

//MARK: - Helper
extension CustomFlowCollectionViewController {
    
    fileprivate func getItem(_ indexPath: IndexPath) -> URL? {
        if self.gifList.count < indexPath.item {
            return nil
        }
        print(#fileID, #function, #line, "- \(indexPath.item)")
        print(#fileID, #function, #line, "- \(self.gifList.count)")
        
        return self.gifList[indexPath.item]
    }
    
    //MARK: - 콜렉션 뷰 UI 업데이트 관련
    // 콜렉션 뷰에 아이템 추가 UI
    fileprivate func insertItemsInCollectionView(_ fetchedUrls: [URL], _ self: CustomFlowCollectionViewController) {
        // 아래 과정을 거치지 않으면 아래로 쌓이지 않는다.
        let appendingIndexPathList: [IndexPath] = fetchedUrls
            .enumerated()
            .map { (index, element) -> IndexPath in
                let startingPoint = self.gifList.count
                return IndexPath(item:startingPoint + index, section: 0)
            }
        
        self.gifList.append(contentsOf: fetchedUrls)
        
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates({
                // reload를 하게 되면 애니메이션 처리가 되지 않기 떄문에 아래와 같은 방식을 사용했다.
                self.collectionView.insertItems(at: appendingIndexPathList)
            })
        }
    }
}

//MARK: - API 호출 관련
extension CustomFlowCollectionViewController {
    
    fileprivate func fetchMoreGiphyList(fetchMoreCompletion: (() -> Void)? = nil) {
        let fetchOffset = currentOffset + fetchLimit
        
        fetchGiphyList(offset: fetchOffset,
                       limit: fetchLimit,
                       completion: { [weak self] fetchedUrls in
            
            guard let self = self else {return}
            
            self.currentOffset += fetchLimit
            
            insertItemsInCollectionView(fetchedUrls, self)
            
            fetchMoreCompletion?()
        })
    }
}

extension CustomFlowCollectionViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        return

        let threshold = 300.0
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if ((bottomEdge + threshold) >= scrollView.contentSize.height) {
            
            let contentHeight = scrollView.contentSize.height
            let scrollHeight = scrollView.frame.size.height
            
            if contentHeight < scrollHeight {
                return
            }
            
            guard !isFetchingMore else { return }
            
            self.isFetchingMore = true
            
            fetchMoreGiphyList(fetchMoreCompletion: {
                self.isFetchingMore = false
            })
        }
    }
}

#if DEBUG
import SwiftUI

struct CustomFlowCollectionViewControllerPreView: PreviewProvider {
    static var previews: some View {
        CustomFlowCollectionViewController().toPreview().previewDevice("iPhone 14 pro")
    }
}
#endif
