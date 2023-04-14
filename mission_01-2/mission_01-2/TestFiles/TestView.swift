//
//  TestView.swift
//  mission_01-2
//
//  Created by Sudon Noh on 2023/04/14.
//

import Foundation
import UIKit
import SnapKit
import Then


class TestView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupUI(){
        self.backgroundColor = .systemYellow
        
        let btn = AlignedIconBtn(
            iconAlign: .leading,
            title: "카카오톡으로 3초만에 시작하기",
            font: UIFont.systemFont(ofSize: 15),
            bgColor: .black,
            icon: UIImage(systemName: "message.fill"),
            padding: UIEdgeInsets(top: 5, left: 70, bottom: 5, right: 40)
        )
        
        self.addSubview(btn)
        
        btn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
    }
}


#if DEBUG
import SwiftUI

struct TestViewPreView: PreviewProvider {
    static var previews: some View {
        TestView().toPreview()
    }
}
#endif
