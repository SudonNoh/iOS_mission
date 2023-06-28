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
        $0.backgroundColor = .green
        $0.dataSource = self
        $0.delegate = self
    }
    
    var pullToRefreshControl: UIRefreshControl = UIRefreshControl().then {
        $0.tintColor = .blue
        $0.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        
        self.setupUI()
        self.setupCollectionView()
        
        fetchGiphyResponse(completion: { [weak self] (gifUrlList: [URL]) in
            guard let self = self else { return }
            self.gifList = gifUrlList
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.collectionView.reloadData()
            }
        })
    }
    
    func fetchGiphyResponse(completion: @escaping ([URL]) -> Void) {
        let url = URL(string: Env.giphyURL + "?api_key=" + Env.giphyKEY)!
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
            
            let urlList: [URL] = giphyList.compactMap { $0.getUrl() }
            
            completion(urlList)
        }
        task.resume()
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        
        fetchGiphyResponse(completion: { [weak self] (gifUrlList: [URL]) in
            guard let self = self else { return }
            self.gifList = gifUrlList
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.collectionView.reloadData()
                sender.endRefreshing()
            }
        })
    }
}

extension CustomFlowCollectionViewController {
    fileprivate func setupUI() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "가져온 움짤"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: self.selectionModeInfo, style: .plain, target: self, action: #selector(toggleSelectionMode(_:)))
        
        
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
        print(#fileID, #function, #line, "- \(indexPath)")
        
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
            for: indexPath
        ) as? CustomFlowCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let cellData: URL = self.gifList[indexPath.item]
        
        cell.configureCell(cellData: cellData,
                           isSelectionMode: self.isSelectionMode,
                           selectedGifList: self.selectedGifList)

        return cell
    }
}

/// CollectionView Delegate
extension CustomFlowCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    /// header & footer 설정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = self.collectionView.bounds.width
        return CGSize(width: width, height: 100)
    }
    
    /// header 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = self.collectionView.bounds.width
        
        if isSelectionMode {
            return CGSize(width: width, height: 30)
        }
        return CGSize(width: width, height: 0)
    }
    
    /// 몇 개씩 보여줄 거냐를 설정할 수 있다
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collectionView.bounds.width / 3) - 15
        return CGSize(width: width, height: width)
    }
    
    /// 셀 당 inset을 주는 방법
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
