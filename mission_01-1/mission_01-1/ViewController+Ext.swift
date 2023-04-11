#if DEBUG
import SwiftUI

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
            let viewController: UIViewController

            func makeUIViewController(context: Context) -> UIViewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            }
        }

        func toPreview() -> some View {
            Preview(viewController: self)
        }
}
#endif

extension UIViewController {
    @objc func clickedLeftArrow() {
        print(#fileID, #function, #line, "- Left Arrow Clicked!")
    }
    
    @objc func clickedRightArrow() {
        print(#fileID, #function, #line, "- Right Arrow Clicked!")
    }
}

extension UIViewController {
    
    /// Navigation Options
    func addNavi(title: String) {
        self.title = title
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(clickedLeftArrow)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.right"),
            style: .plain,
            target: self,
            action: #selector(clickedRightArrow)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationController?.navigationBar.backgroundColor = .systemGray6
    }
}

class dot: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(txt:String) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = txt
        self.textAlignment = .center
    }
}

class contentLbl: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(txt:String) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = txt
        self.textAlignment = .left
        self.numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: 16)
    }
}
