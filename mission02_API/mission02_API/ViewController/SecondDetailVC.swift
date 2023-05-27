import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay

class SecondDetailVC: CustomVC {
    
    // ScrollView Setting =================================================⬇️
    lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.addSubview(containerView)
    }
    
    lazy var containerView: UIView = UIView().then {
        $0.addSubview(infoBoxView)
        $0.addSubview(contentBoxView)
        
        infoBoxView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        contentBoxView.snp.makeConstraints {
            $0.top.equalTo(infoBoxView.snp.bottom).offset(10)
            $0.leading.equalTo(infoBoxView)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    // ScrollView Setting =================================================⬆️
    
    // infoBoxView ========================================================⬇️
    lazy var infoBoxView : UIView = UIView().then {
        $0.addSubview(idLabel)
        $0.addSubview(emailLabel)
        $0.addSubview(avatarLabel)
        
        idLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        avatarLabel.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    lazy var idLabel : UILabel = UILabel().then {
        $0.text = "id: "
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .textColor
        $0.lineBreakMode = .byCharWrapping
    }
    
    lazy var emailLabel : UILabel = UILabel().then {
        $0.text = "Email : "
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .textColor
        $0.lineBreakMode = .byCharWrapping
    }
    
    lazy var avatarLabel : UILabel = UILabel().then {
        $0.text = "Avatar : "
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .textColor
        $0.lineBreakMode = .byCharWrapping
    }
    // infoBoxView =======================================================⬆️
    
    // contentBoxView ====================================================⬇️
    lazy var contentBoxView : UIView = UIView().then {
        $0.addSubview(titleLabel)
        $0.addSubview(contentLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    lazy var titleLabel: UILabel = UILabel().then {
        $0.text = "Title : "
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .textColor
        $0.lineBreakMode = .byCharWrapping
    }
    
    lazy var contentLabel: UILabel = UILabel().then {
        $0.text = "Content : "
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .textColor
        $0.lineBreakMode = .byCharWrapping
    }
    // contentBoxView ====================================================⬆️
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        guard let id = self.title else {return}
        var mocks = DetailMocksVM(id: id)
        mocks
            .mock
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { (VC, mock) in
                self.settingContent(mock: mock)
            }.disposed(by: disposeBag)
    }
    
    fileprivate func setupUI() {
        self.view.backgroundColor = .bgColor
        self.navigationController?.navigationBar.tintColor = .white
        
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide.snp.edges)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
            $0.bottom.equalTo(contentLabel.snp.bottom).offset(20)
        }
    }
    
    func settingContent(mock: Mock?) {
        guard let data = mock else { return }
        guard let id = data.id,
              let email = data.email,
              let avatar = data.avatar,
              let title = data.title,
              let content = data.content else { return }
        
        self.idLabel.text = "ID : \(id)"
        self.emailLabel.text = "Email : " + email
        self.avatarLabel.text = "Avatar : " + avatar
        self.titleLabel.text = "Title : " + title
        self.contentLabel.text = "Content : " + content
    }
}
