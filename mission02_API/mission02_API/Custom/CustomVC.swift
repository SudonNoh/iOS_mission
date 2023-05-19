import Foundation
import UIKit

class CustomVC : UIViewController {
    /// Status 상태바의 텍스트 색상을 하얀색으로 바꾸기 위해 추가
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .black
    }
}
