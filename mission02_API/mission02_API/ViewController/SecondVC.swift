//
//  SecondVC.swift
//  mission02_API
//
//  Created by Sudon Noh on 2023/05/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay


class SecondVC: CustomVC {
    
    var disposeBag = DisposeBag()
    
    var mocksVM: MocksVM = MocksVM()
    
    lazy var searchBar : UISearchBar = UISearchBar().then {
        $0.placeholder = "검색어를 입력해주세요."
        $0.searchTextField.textColor = .searchBarTextColor
        $0.searchTextField.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        $0.searchTextField.backgroundColor = .textColor
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowOffset = CGSize(width: 0.7, height: 5.0)
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOpacity = 3.0
    }
    
    lazy var mockTableView : UITableView = UITableView().then {
        $0.backgroundColor = .bgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.mockTableView.register(MockCell.self, forCellReuseIdentifier: "MockCell")
        
        self.mocksVM
            .mocks
            .bind(to:self.mockTableView.rx.items(cellIdentifier: "MockCell", cellType: MockCell.self)) {[weak self] idx, cellData, cell in
                guard let self = self else { return }
                cell.updateUI(cellData)
            }
            .disposed(by: disposeBag)
        
        self.mocksVM
            .errorMsg
            .skip(1)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { VC, msg in
                VC.showErrorAlert(errMsg: msg)
            }).disposed(by: disposeBag)
    }
}

// UI Setup
extension SecondVC {
    
    func setup() {
        self.view.backgroundColor = .bgColor
        self.navigationItem.titleView = searchBar
        
        self.view.addSubview(mockTableView)
        
        mockTableView.snp.makeConstraints {
            $0.verticalEdges.equalTo(self.view.safeAreaLayoutGuide.snp.verticalEdges).inset(20)
            $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide.snp.horizontalEdges).inset(15)
        }
    }
}

//MARK: - Alert
extension SecondVC {
    @objc fileprivate func showErrorAlert(errMsg: String){
        let alert = UIAlertController(title: "안내", message: errMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}
