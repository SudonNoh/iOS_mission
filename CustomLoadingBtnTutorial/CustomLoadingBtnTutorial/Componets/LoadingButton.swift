import Foundation
import UIKit

class LoadingButton : UIButton {
    
    // 로딩 상태
    enum LoadingState {
        case normal
        case loading
    }
    
    var indicator : UIActivityIndicatorView? = nil
    
    // 로딩 상태 변수
    var loadingState : LoadingState = .normal {
        didSet {
            DispatchQueue.main.async {
                switch self.loadingState {
                case .normal: self.hideLoading()
                case .loading: self.showLoading()
                }
            }
        }
    }
    
    // 아이콘 정렬
    enum IconAlignment {
        case leading
        case trailing
    }
    
    // 아이콘 정렬 기본값은 left
    var iconAlignment : IconAlignment = .leading
    
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    // button이 생성될 때
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#fileID, #function, #line, "- ")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// convenience init
    /// 기존 생성자 + 추가적인 매개변수를 넣고 싶을 때 사용
    convenience init(
        iconAlign: IconAlignment = .leading,
        title: String = "타이틀 없음",
        font: UIFont = UIFont.Sunflower(.bold, size:20),
        bgColor: UIColor = .systemBlue,
        tintColor: UIColor = .white,
        cornerRadius: CGFloat = 8,
        icon: UIImage? = nil,
        padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    ) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = bgColor
        self.tintColor = tintColor
        self.layer.cornerRadius = cornerRadius
        self.setImage(icon, for: .normal)
        self.padding = padding
        self.iconAlignment = iconAlign
    }
    
    /// button이 layout 위치에 들어갈 때
    override func layoutSubviews() {
        super.layoutSubviews()
        print(#fileID, #function, #line, "- ")
        
        /// 이곳에서 이미지 위치를 조절하는 이유는 생성자를 통해 생성할 때는
        /// 높이, 넓이 등이 없기 때문에 계산을 위해서 layoutSubviews에서 계산한다.
        switch iconAlignment {
        case .leading: // 왼쪽 정렬
            alignIconLeading()
        case .trailing: // 오른쪽 정렬
            alignIconTrailing()
        }
        
        contentEdgeInsets = padding
    }
}

//MARK: - 아이콘 정렬 관련
extension LoadingButton {
    /// 아이콘 왼쪽 정렬
    fileprivate func alignIconLeading() {
        contentHorizontalAlignment = .left
        
        let imgWidth = imageView?.frame.width ?? 0
        
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.right - ( imageView?.frame.width ?? 0 ) - (titleLabel?.frame.width ?? 0)
        let leftPadding = (availableWidth / 2) - ( imgWidth / 2)
        // 타이틀에 Padding 넣기
        titleEdgeInsets = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 0)
    }
    
    /// 아이콘 오른쪽 정렬
    fileprivate func alignIconTrailing() {
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .right
        
        let imgWidth = imageView?.frame.width ?? 0
        
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.left - ( imageView?.frame.width ?? 0 ) - (titleLabel?.frame.width ?? 0)
        let rightPadding = (availableWidth / 2) - ( imgWidth / 2)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightPadding)
    }
}

//MARK: - 로딩 관련
extension LoadingButton {
    
    /// 로딩 숨기기
    fileprivate func hideLoading() {
        
        // self.isUserInteractionEnabled = true
        
        UIView.transition(with: self,
                          duration: 0.5,
                          options: .curveEaseIn,
                          animations: {
            self.titleLabel?.alpha = 1
            self.imageView?.alpha = 1
            self.indicator?.alpha = 0
        })
    }
    
    /// 로딩 보이기
    fileprivate func showLoading() {
        
        // self.isUserInteractionEnabled = false
        
        // indicator 준비 과정
        if self.indicator == nil {
            let btnIndicator = UIActivityIndicatorView(style: .large).then {
                $0.color = .white
                $0.startAnimating()
            }
            self.addSubview(btnIndicator)
            btnIndicator.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            self.indicator = btnIndicator
        }
        
        // indicator가 실제로 나타나는 과정
        UIView.transition(with: self,
                          duration: 0.5,
                          options: .curveEaseOut,
                          animations: {
            self.titleLabel?.alpha = 0
            self.imageView?.alpha = 0
            
            self.indicator?.alpha = 1
        })
    }
}
