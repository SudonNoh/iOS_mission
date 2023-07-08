import UIKit
import SnapKit
import Then


class TitleSupplementaryView: UICollectionReusableView {
    let label = UILabel()
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    lazy var btn: UIButton = UIButton().then {
        $0.setTitle("버튼", for: .normal)
        $0.backgroundColor = .blue
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TitleSupplementaryView {
    func configure() {
        addSubview(btn)
        addSubview(label)
        backgroundColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        btn.addTarget(self, action: #selector(clickedBtn(_:)), for: .touchUpInside)
        btn.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        label.font = UIFont.preferredFont(forTextStyle: .title3)
    }
    
    @objc func clickedBtn(_ sender: UIButton) {
        print(sender.titleLabel?.text)
    }
}
