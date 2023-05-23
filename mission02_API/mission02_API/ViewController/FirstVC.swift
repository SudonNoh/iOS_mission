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
    
    lazy var mockTableView : UITableView = UITableView().then {
        $0.backgroundColor = .bgColor
    }
    
    //MARK: - FirstView viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.mockTableView.register(MockCell.self, forCellReuseIdentifier: "MockCell")
        self.mockTableView.dataSource = self
        self.mockTableView.delegate = self
        
        self.mocksVM
            .mocks
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { VC, updateData in
                VC.mockTableView.reloadData()
            }).disposed(by: disposeBag)
        
        // Error 처리
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

//MARK: - Alert
extension FirstVC {
    @objc fileprivate func showErrorAlert(errMsg: String){
        let alert = UIAlertController(title: "안내", message: errMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UI Setup
extension FirstVC {
    
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
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler) in
//            self.dataSource.remove(at: indexPath.row)
//            self.todoTableView.deleteRows(at: [indexPath], with: .automatic)
//            print(#fileID, #function, #line, "- \(indexPath.row + 1) 번째 행이 삭제됐습니다.")
//            completionHandler(true)
//        }
//        deleteAction.backgroundColor = .red
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
}
