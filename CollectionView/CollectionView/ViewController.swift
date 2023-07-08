//
//  ViewController.swift
//  CollectionView
//
//  Created by Sudon Noh on 2023/07/08.
//

import Foundation
import SnapKit
import Then
import UIKit


class ViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                 collectionViewLayout: createLayout()).then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.backgroundColor = .white
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.constraints()
    }
    
    fileprivate func setupUI() {
        print(#fileID, #function, #line, "- ")
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        self.configureDataSource()
    }
    
    fileprivate func constraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

extension ViewController {

    fileprivate func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        // layout 설정
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            // item 설정
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.7)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            // group 설정
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.7)),
                subitems: [item])
            containerGroup.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            // section 설정
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            // section Header 설정
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(120)),
                elementKind: "header-element-kind",
                alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }, configuration: config)
        
        return layout
    }
    
    func configureDataSource() {
        // CellRegistration<Cell, Item>
        let cellRegistration = UICollectionView.CellRegistration<CollectionViewCell, Int> {(cell, indexPath, identifier) in
            cell.label.text = "\(indexPath.section), \(indexPath.item)"
        }
        
        // UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: "header-element-kind") {
            (supplementaryView, string, indexPath) in
            let sectionKind = "지정된 값 입니다. + indexPath: \(indexPath), string: \(string)"
            supplementaryView.label.text = String(describing: sectionKind)
            supplementaryView.btn.setTitle("\(indexPath.section) + 버튼", for: .normal)
        }
        
        dataSource.supplementaryViewProvider = {(view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
        
        // initial data
        // 데이터 설정
        // NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var identifierOffset = 0
        let itemPerSection = 5
        
        for i in 0...5 {
            // 여기서 identifier를 설정
            snapshot.appendSections([i])
            let maxIdentifier = identifierOffset + itemPerSection
            // 각 아이템별 사진 수
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemPerSection
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
