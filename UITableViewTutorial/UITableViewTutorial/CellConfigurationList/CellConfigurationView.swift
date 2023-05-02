import Foundation
import UIKit


// 뷰인데 Config를 가지고 있는 뷰
class CellConfigurationView: UIView, UIContentView {
    
    fileprivate var customConfiguration : MyCellConfiguration!
    
    var configuration: UIContentConfiguration {
        get { customConfiguration }
        set {
            if let newConfiguration = newValue as? MyCellConfiguration {
                // Update가 될 경우
                print(#fileID, #function, #line, "- 선택됨!!")
                applyConfigAndChangeUI(newConfiguration)
            }
        }
    }
    
    init(config: MyCellConfiguration) {
        super.init(frame: .zero)
        setupUI()
        // 그러니까 초기값을 갖고 있는 상태에서 외부로부터 데이터를 받으면 이 로직을 타서
        // 데이터를 UI에 맞게 적용시킨다.
        print(#fileID, #function, #line, "- 초기값 설정됨")
        applyConfigAndChangeUI(config)
    }
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "타이틀 라벨"
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "바디 라벨"
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(#fileID, #function, #line, "- layoutSubviews")
    }
    
    /// 레이아웃 처리
    fileprivate func setupUI() {
        print(#fileID, #function, #line, "- CodeCell")
        
        self.backgroundColor = .systemBlue
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.bodyLabel)
        
        // 타이틀 라벨 설정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
        
        // 바디 라벨 설정
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            bodyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    // 데이터와 UI 연결
    fileprivate func applyConfigAndChangeUI(_ newConfiguration: MyCellConfiguration) {
        print(#fileID, #function, #line, "- Apply!!")
        self.customConfiguration = newConfiguration
        titleLabel.text = newConfiguration.title
        bodyLabel.text = newConfiguration.body
    }
}


#if DEBUG
import SwiftUI

struct CellConfigurationViewPreView: PreviewProvider {
    static var previews: some View {
        CellConfigurationView(
            config: MyCellConfiguration(title: "오늘도 빡코딩", body: "호롤로롤")
        ).toPreview()
            .previewLayout(.fixed(width: 200, height: 100))
    }
}
#endif
