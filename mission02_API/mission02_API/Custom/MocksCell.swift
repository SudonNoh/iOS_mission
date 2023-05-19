import Foundation
import UIKit
import SnapKit
import Then

class MocksCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = UILabel().then {
        $0.text = "해야 할 일들을 정리하는 곳 입니다."
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .textColor
        $0.lineBreakMode = .byCharWrapping
    }
    
    lazy var dateStackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.addArrangedSubview(updatedDateLabel)
        $0.addArrangedSubview(createdDateLabel)
    }
    
    lazy var updatedDateLabel: UILabel = UILabel().then {
        $0.text = "Update: 9999-99-99 24시 59분"
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .textColor
        $0.textAlignment = .center
    }
    
    lazy var createdDateLabel: UILabel = UILabel().then {
        $0.text = "Create: 9999-99-99 24시 59분"
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .textColor
        $0.textAlignment = .center
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupUI() {
        self.backgroundColor = .bgColor
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dateStackView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}
