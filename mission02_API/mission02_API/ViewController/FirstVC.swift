import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay
import RxCocoa


class FirstVC: CustomVC {
    
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
    
    lazy var pageNumLbl : UILabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 10)
    }
    
    lazy var mockTableView : UITableView = UITableView().then {
        $0.backgroundColor = .bgColor
    }
    
    lazy var bottomIndicator: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = UIColor.systemBlue
        $0.startAnimating()
        $0.frame = CGRect(x: 0, y: 0, width: self.mockTableView.bounds.width, height: 44)
    }
    
    //MARK: - 질문 4. bottomNoMoreDataView가 보이지 않는다.
    lazy var bottomNoMoreDataView: UIView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: mockTableView.bounds.width, height: 60)
        $0.backgroundColor = .blue

        let label = UILabel().then {
            $0.text = "더 이상 가져올 데이터가 없습니다."
            $0.textColor = .white
        }

        $0.addSubview(label)

        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    //MARK: - FirstView viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.mockTableView.tableFooterView = bottomIndicator
        self.mockTableView.register(MockCell.self, forCellReuseIdentifier: "MockCell")
        self.mockTableView.dataSource = self
        self.mockTableView.delegate = self

        /// Mocks List Update
        self.mocksVM
            .mocks
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { VC, updateData in
                VC.mockTableView.reloadData()
            }).disposed(by: disposeBag)
        
        /// Loading  처리
        self.mocksVM
            .isLoading
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { VC, isLoading in
                self.mockTableView.tableFooterView = isLoading ? self.bottomIndicator : nil
            })
            .disposed(by: disposeBag)
            
        /// Error
        //MARK: - 질문 1. Rx 에러 처리 방식이 맞는지?
        self.mocksVM
            .errorMsg
            .skip(1)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { VC, msg in
                VC.showErrorAlert(errMsg: msg)
                self.mocksVM.isLoading.accept(false)
            }).disposed(by: disposeBag)
        
        /// Bottom Event
        self.mockTableView
            .rx.bottomReached
            .bind(onNext: { self.mocksVM.fetchMocksMore() })
            .disposed(by: disposeBag)
        
        /// Paging
        self.mocksVM
            .notifyHasNextPage
            .debug("❤️")
            .observe(on: MainScheduler.instance)
            .map { !$0 ? self.bottomNoMoreDataView : nil }
            .bind(to: self.mockTableView.rx.tableFooterView)
            .disposed(by: disposeBag)
        
        self.mocksVM
            .currentPageInfo
            .observe(on: MainScheduler.instance)
            .bind(to: self.pageNumLbl.rx.text)
            .disposed(by: disposeBag)
    }
}

//MARK: - Alert
extension FirstVC {
    @objc fileprivate func showErrorAlert(errMsg: String){
        let alert = UIAlertController(title: "안내", message: errMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc fileprivate func showDeleteAlert(completion: (() -> Void)? = nil){
        let alert = UIAlertController(title: "삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default) {(_) in
            completion?()
        }
        let cancelAction = UIAlertAction(title: "아니요", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

//MARK: - UI Setup
extension FirstVC {
    
    fileprivate func setup() {
        self.view.backgroundColor = .bgColor
        self.navigationItem.titleView = searchBar
        
        self.view.addSubview(mockTableView)
        self.view.addSubview(pageNumLbl)
        
        pageNumLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(12)
        }
        
        mockTableView.snp.makeConstraints {
            $0.top.equalTo(pageNumLbl.snp.bottom).offset(12)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide.snp.horizontalEdges).inset(15)
        }
    }
}

//MARK: - TableView DataSource
extension FirstVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mocksVM.mocks.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MockCell", for: indexPath) as? MockCell else {
            return UITableViewCell()
        }
        
        let cellData = self.mocksVM.mocks.value[indexPath.row]
        
        guard let id = cellData.id,
              let email = cellData.email,
              let avatar = cellData.avatar,
              let title = cellData.title,
              let content = cellData.content else { return UITableViewCell() }
        
        cell.idLabel.text = "\(id)"
        cell.emailLabel.text = email
        cell.avatarLabel.text = avatar
        cell.titleLabel.text = title
        cell.contentLabel.text = content
                
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.textPoint?.cgColor
        cell.layer.cornerRadius = 4

        return cell
    }
}

//MARK: - TableView Delegate
extension FirstVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "- \(indexPath.row + 1) 번째 행이 클릭되었습니다. !")
        let vc = FirstDetailVC()
        guard let id = self.mocksVM.mocks.value[indexPath.row].id else { return }
        vc.title = "\(id)"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler) in
            
            self.showDeleteAlert() {
                //MARK: - 질문2. 이런 식으로 요소를 삭제하는 것이 맞는지?
                var updateValue = self.mocksVM.mocks.value // Array<Mock>
                updateValue.remove(at: indexPath.row)
                self.mocksVM.mocks.accept(updateValue)
                
                completionHandler(true)
            }

            completionHandler(false)
        }
        deleteAction.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
