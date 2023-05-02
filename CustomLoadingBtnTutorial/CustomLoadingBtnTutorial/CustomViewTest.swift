//
//  CustomViewTest.swift
//  CustomLoadingBtnTutorial
//
//  Created by Sudon Noh on 2023/04/06.
//

import Foundation
import UIKit
import SnapKit
import Then


class CustomViewTest: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupUI(){
        self.backgroundColor = .systemYellow
        
        let btn = LoadingButton(
            indicatorType: .material,
            iconAlign: .trailing,
            title: "버튼",
            bgColor: .systemCyan,
            tintColor: .white,
            cornerRadius: 10,
            icon: UIImage(systemName: "pencil.circle")
        )
        
        btn.loadingState = .loading
        
        self.addSubview(btn)
        
        btn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
    }
}

#if DEBUG
import SwiftUI

struct CustomViewTestPreView: PreviewProvider {
    static var previews: some View {
        CustomViewTest()
            .toPreview()
            .previewLayout(.sizeThatFits)
            .frame(width: 250, height: 200)
    }
}
#endif
