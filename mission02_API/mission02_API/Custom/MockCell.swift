import Foundation
import UIKit
import SnapKit
import Then

class MockCell: UITableViewCell {

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
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .textColor
        $0.lineBreakMode = .byCharWrapping
    }
    
    lazy var emailLabel : UILabel = UILabel().then {
        $0.text = "Email : "
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .textColor
        $0.lineBreakMode = .byCharWrapping
    }
    
    lazy var avatarLabel : UILabel = UILabel().then {
        $0.text = "Avatar : "
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
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
            $0.bottom.equalToSuperview()
        }
    }
    
    lazy var titleLabel: UILabel = UILabel().then {
        $0.text = "Title : "
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .textColor
        $0.lineBreakMode = .byCharWrapping
    }
    
    lazy var contentLabel: UILabel = UILabel().then {
        $0.text = "Content : "
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .textColor
        $0.lineBreakMode = .byCharWrapping
    }
    // contentBoxView ====================================================⬆️
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupUI() {
        self.backgroundColor = .bgColor
        
        self.contentView.addSubview(infoBoxView)
        self.contentView.addSubview(contentBoxView)
        
        infoBoxView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        contentBoxView.snp.makeConstraints {
            $0.top.equalTo(infoBoxView.snp.bottom).offset(10)
            $0.leading.equalTo(infoBoxView)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    // SecondVC
    func updateUI(_ cellData: Mock) {
        guard let id = cellData.id,
              let email = cellData.email,
              let avatar = cellData.avatar,
              let title = cellData.title,
              let content = cellData.content else { return }
        
        self.idLabel.text = "id: \(id)"
        self.emailLabel.text = email
        self.avatarLabel.text = avatar
        self.titleLabel.text = title
        self.contentLabel.text = content
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.textPoint?.cgColor
        self.layer.cornerRadius = 4
    }
}


#if DEBUG
import SwiftUI

struct MockCellPreView: PreviewProvider {
    static var previews: some View {
        MockCell()
            .toPreview()
            .previewLayout(.sizeThatFits)
            .frame(width: 370, height: 250)
    }
}
#endif
