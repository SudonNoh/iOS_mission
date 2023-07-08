

import Foundation
import UIKit
import SnapKit
import Then

class CollectionViewCell: UICollectionViewCell {
    
    lazy var img: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "photo")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .brown
    }
    
    lazy var label: UILabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupUI() {
        addSubview(img)
        addSubview(label)
        
        img.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(img.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
