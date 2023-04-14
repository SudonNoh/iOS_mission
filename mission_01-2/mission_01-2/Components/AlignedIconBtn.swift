//
//  CustomLoginBtn.swift
//  mission_01-2
//
//  Created by Sudon Noh on 2023/04/13.
//

import Foundation
import UIKit


class AlignedIconBtn: UIButton {
    
    // 아이콘 정렬
    enum IconAlignment {
        case leading
        case trailing
    }
    
    var iconAlignment : IconAlignment = .leading
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(
        iconAlign: IconAlignment = .leading,
        title: String = "타이틀 없음",
        font: UIFont = UIFont.systemFont(ofSize: 20),
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch iconAlignment {
        case .leading:
            alignIconLeading()
        case .trailing:
            alignIconTrailing()
        }
        
        contentEdgeInsets = padding
    }
}

//MARK: - icon Alignment Setting
extension AlignedIconBtn {
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
