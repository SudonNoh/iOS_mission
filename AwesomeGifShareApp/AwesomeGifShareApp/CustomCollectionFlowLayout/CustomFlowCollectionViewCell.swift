import Foundation
import UIKit
import SnapKit
import Then
import SwiftyGif

class CustomFlowCollectionViewCell : UICollectionViewCell {
    
    lazy var imgView: UIImageView = UIImageView().then {
        $0.image = .none
        $0.layer.shadowOffset = CGSize(width: 5, height: 5)
        $0.layer.shadowOpacity = 0.7
        $0.layer.shadowRadius = 5
        $0.layer.shadowColor = UIColor.gray.cgColor
        
        $0.addSubview(checkBoxImgView)
        
        checkBoxImgView.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(25)
        }
    }
    
    lazy var checkBoxImgView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "checkbox - normal")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupUI() {
        self.contentView.addSubview(self.imgView)
        
        self.imgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // 메모리 관리를 위해 Reuse 되기 전 부분의 애니메이션을 멈춘다.
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.stopAnimating()
    }
    
    func configureCell(cellData: URL, isSelectionMode: Bool, selectedGifList: Set<String>) {
        // SwiftyGif
        self.imgView.setGifFromURL(cellData, showLoader: true)
        self.imgView.startAnimating()

        self.checkBoxImgView.isHidden = !isSelectionMode
        
        let isSelected = selectedGifList.contains(cellData.absoluteString)
        let seletionImg = isSelected ? UIImage(named: "checkbox - completed")! : UIImage(named: "checkbox - normal")!
        
        self.checkBoxImgView.setImage(seletionImg)
    }
}

#if DEBUG
import SwiftUI

struct CustomFlowCollectionViewCellPreView: PreviewProvider {
    static var previews: some View {
        CustomFlowCollectionViewCell().toPreview().previewDevice("iPhone 14 pro")
    }
}
#endif
