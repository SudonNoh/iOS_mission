//
//  SecondVC.swift
//  mission_01-1
//
//  Created by Sudon Noh on 2023/03/30.
//

import UIKit

class SecondVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .yellow
    }
}

#if DEBUG
import SwiftUI

struct SecondVCPreView: PreviewProvider {
    static var previews: some View {
        SecondVC().toPreview().ignoresSafeArea()
    }
}
#endif
