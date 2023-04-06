import UIKit

class CustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupUI() {
        self.backgroundColor = .systemBlue
    }
}


#if DEBUG
import SwiftUI

struct CustomViewPreView: PreviewProvider {
    static var previews: some View {
        CustomView()
            .toPreview()
            .frame(width: 200, height: 200)
            .padding(10)
            .background(Color.green)
            .previewLayout(.sizeThatFits)
    }
}
#endif
