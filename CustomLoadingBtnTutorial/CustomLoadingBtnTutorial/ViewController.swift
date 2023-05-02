//
//  ViewController.swift
//  CustomLoadingBtnTutorial
//
//  Created by Sudon Noh on 2023/04/06.
//

import UIKit
import SnapKit
import Then
import Combine
import RxCocoa
import RxSwift


class ViewController: UIViewController {
    
    // combine
    // 데이터의 상태
    @Published var loadingState : LoadingButton.LoadingState = .normal
    // 뷰컨트롤러가 메모리에서 해제될 때 같이 해제
    var subscriptions = Set<AnyCancellable>()
    
    // rx
    let loadingStateRx = BehaviorRelay<LoadingButton.LoadingState>(value:.normal)
    let disposeBag = DisposeBag()

    
    lazy var myScrollView : UIScrollView = UIScrollView().then {
        $0.isUserInteractionEnabled = true
        $0.alwaysBounceVertical = true
        $0.alwaysBounceHorizontal = false
        $0.addSubview(containerView)
    }
    
    lazy var containerView : UIView = UIView().then {
        $0.backgroundColor = .systemYellow
        $0.addSubview(btnStackView)
    }
    
    lazy var btnStackView : UIStackView = UIStackView().then {
        // 아이템 간 간격
        $0.spacing = 10
        $0.alignment = .fill
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemCyan
        
        setupUI()
    }
    
    /// UI설정
    fileprivate func setupUI() {
        print(#fileID, #function, #line, "- ")
        self.view.addSubview(myScrollView)
        
        // ScrollView
        myScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // ContainerView
        containerView.snp.makeConstraints {
            $0.width.equalTo(myScrollView.frameLayoutGuide.snp.width)
            $0.edges.equalTo(myScrollView.contentLayoutGuide.snp.edges)
        }
        
        let dummyBtns: [LoadingButton] = Array(0...20).map { index in
//            UIButton(configuration: .filled()).then {
//                $0.setTitle("Button \(index)", for: .normal)
//            }
            LoadingButton(
                title: "버튼 \(index)",
                bgColor: .systemCyan,
                tintColor: .black,
                cornerRadius: 10,
                icon: UIImage(systemName: "pencil.circle")
            )
        }
        
        let dummyBtns2: [LoadingButton] = IndicatorType.allCases.map {
            type in
            LoadingButton(
                indicatorType: type,
                title: type.rawValue,
                bgColor: .systemCyan,
                tintColor: .white,
                cornerRadius: 10,
                icon: UIImage(systemName: "pencil.circle")
            )
        }
        
        // BtnStackView
        btnStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        dummyBtns2.forEach {
            btnStackView.addArrangedSubview($0)
            $0.addTarget(self, action: #selector(onBtnClicked(_:)), for: .touchUpInside)
            
            // 콤바인 퍼블리셔 데이터 상태를 버튼의 loadingState에 연결
            // self.$loadingState
            //     .assign(to: \.loadingState, on: $0)
            //     .store(in: &subscriptions)
            
            // Rx 옵저버블 데이터 상태 <-> 버튼의 loadingState
            self.loadingStateRx
                .bind(to: $0.rx.loadingState)
                .disposed(by: disposeBag)
        }
        
        let loadingStateLbl = UILabel().then {
            $0.text = "로딩상태 라벨"
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.backgroundColor = .white
        }
        
        self.view.addSubview(loadingStateLbl)
        
        loadingStateLbl.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        // combine
        // self.$loadingState
        //     .map { $0 == .loading ? "로딩 중" : "일반"}
        //     .assign(to: \.text, on: loadingStateLbl)
        //     .store(in: &subscriptions)
        
        self.loadingStateRx
            .map { $0 == .loading ? "로딩 중" : "일반"}
            .bind(to: loadingStateLbl.rx.text)
            .disposed(by: disposeBag)
    }
}

//MARK: - 액션 관련
extension ViewController {
    
    /// 버튼 클릭시
    /// - Parameter sender: 클릭한 버튼
    @objc fileprivate func onBtnClicked(_ sender: LoadingButton) {
        // Rx 방식
        if self.loadingStateRx.value == .loading {
            return
        }
        
        self.loadingStateRx.accept(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.loadingStateRx.accept(.normal)
        })
        
        
        // sender.loadingState = sender.loadingState == .normal ? .loading : .normal
        
        // 위의 방식에서는 sender 기준으로 상태를 결정했다면 아래 방법은 data를 기준으로 상태를 결정하는 방법이다.
        // Combine 방식
        // 콤바인의 Publisher 데이터 상태를 변경한다
        // if self.loadingState == .normal {
        //    self.loadingState = .loading
        // } else {
        //    self.loadingState = .normal
        // }
        
        // 로딩이 한번 시작되면 더이상 터치하지 못하도록 하는 코드
        // if self.loadingState == .loading {
        //    return
        // }
        
        // self.loadingState = .loading
        
        // 버튼을 누르면 2초 뒤에 다시 normal로 바꿔주는 코드
        // DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
        //     self.loadingState = .normal
        // })
    }
}

#if DEBUG
import SwiftUI

struct ViewControllerPreView: PreviewProvider {
    static var previews: some View {
        ViewController().toPreview().ignoresSafeArea()
    }
}
#endif
