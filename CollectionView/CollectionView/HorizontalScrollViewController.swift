//
//  ViewController.swift
//  CollectionView
//
//  Created by Sudon Noh on 2023/07/06.
//

import Foundation
import UIKit
import SnapKit
import Then

class HorizontalScrollViewController: UIViewController {
    
    lazy var pageControl: UIPageControl = UIPageControl().then {
        $0.numberOfPages = 5
        $0.currentPageIndicatorTintColor = .black
        $0.currentPage = 0
    }
    
    lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.addSubview(containerView)
        $0.isPagingEnabled = true
        $0.delegate = self
    }
    
    lazy var containerView: UIView = UIView().then {
        $0.backgroundColor = .yellow

        $0.addSubview(view1)
        $0.addSubview(view2)
        $0.addSubview(view3)
        $0.addSubview(view4)
        $0.addSubview(view5)
    }
    
    lazy var view1: UIView = UIView().then {
        $0.backgroundColor = .blue
    }
    
    lazy var view2: UIView = UIView().then {
        $0.backgroundColor = .brown
    }
    
    lazy var view3: UIView = UIView().then {
        $0.backgroundColor = .cyan
    }
    
    lazy var view4: UIView = UIView().then {
        $0.backgroundColor = .darkGray
    }
    
    lazy var view5: UIView = UIView().then {
        $0.backgroundColor = .green
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        self.view.addSubview(pageControl)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide.snp.horizontalEdges)
            $0.height.equalTo(400)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom)
            $0.horizontalEdges.equalTo(scrollView.snp.horizontalEdges)
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalTo(self.scrollView.contentLayoutGuide.snp.edges)
            $0.height.equalTo(self.scrollView.frameLayoutGuide.snp.height)
            $0.trailing.equalTo(view5.snp.trailing)
        }
        
        view1.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(self.view.bounds.width)
        }
        
        view2.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(view1.snp.trailing)
            $0.width.equalTo(self.view.bounds.width)
        }
        
        view3.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(view2.snp.trailing)
            $0.width.equalTo(self.view.bounds.width)
        }
        
        view4.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(view3.snp.trailing)
            $0.width.equalTo(self.view.bounds.width)
        }
        
        view5.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(view4.snp.trailing)
            $0.width.equalTo(self.view.bounds.width)
        }
    }
    
    fileprivate func setPageControlSeletedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}

extension HorizontalScrollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        setPageControlSeletedPage(currentPage: Int(round(value)))
    }
}
