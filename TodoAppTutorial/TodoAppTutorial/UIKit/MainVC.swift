//
//  mainVC.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import Foundation
import UIKit
import SwiftUI


class MainVC: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var dummyDataList = ["asgearg", "dsfgxcv", "sdfg", "sdhdrthrth", "Sdfgxf", "asgearg", "dsfgxcv", "sdfg", "sdhdrthrth", "Sdfgxf", "asgearg", "dsfgxcv", "sdfg", "sdhdrthrth", "Sdfgxf", "asgearg", "dsfgxcv", "sdfg", "sdhdrthrth", "Sdfgxf"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        self.view.backgroundColor = .systemYellow
        
        self.myTableView.register(TodoCell.uiNib, forCellReuseIdentifier: TodoCell.reuseIdentifire)
        self.myTableView.dataSource = self
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifire, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}

//MARK: - Nibbed 이름 설정
protocol Nibbed {
    static var uiNib: UINib { get }
}

extension Nibbed {
    static var uiNib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}

extension UITableViewCell : Nibbed { }

//MARK: - ReuseIdentifier 이름 설정
protocol ReuseIdentifiable {
    static var reuseIdentifire: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifire: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell : ReuseIdentifiable { }

// 아래 과정은 UIKit로 만든 Storyboard를 SwiftUI로 보기 가져가기 위한 로직이다.
// SwiftUI View
extension MainVC {
    private struct VCRepresentable : UIViewControllerRepresentable {
        
        let mainVC : MainVC
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return mainVC
        }
    }
    
    func getRepresentable() -> some View {
        VCRepresentable(mainVC: self)
    }
}

extension UIViewController: StoryBoarded { }

protocol StoryBoarded {
    static func instantiate(_ storyboardName: String?) -> Self
}

extension StoryBoarded {
    static func instantiate(_ storyboardName: String? = nil) -> Self {
        let name = storyboardName ?? String(describing: Self.self)
        print(#fileID, #function, #line, "- \(name)")
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
    }
}

