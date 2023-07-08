//
//  ViewController.swift
//  CollectionView
//
//  Created by Sudon Noh on 2023/07/06.
//

import UIKit
import SnapKit
import Then


class HorizontalViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                 collectionViewLayout: createLayout()).then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.backgroundColor = .systemBackground
        $0.delegate = self
        $0.dataSource = self
        $0.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
    }
}

extension HorizontalViewController {
    fileprivate func setupUI() {
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.center.equalToSuperview()
            $0.height.width.equalTo(300)
        }
    }
}

extension HorizontalViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension HorizontalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "- \(indexPath)")
    }
}

extension HorizontalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                            for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }

        return cell
    }
}

