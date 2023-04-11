//
//  SecondVC.swift
//  mission_01-1
//
//  Created by Sudon Noh on 2023/03/30.
//

import UIKit

class SecondVC: UIViewController {
    
    let searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = .lightGray

        view.addSubview(border)

        NSLayoutConstraint.activate([
            border.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            border.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        return view
    }()
    
    let searchImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .black
        imgView.contentMode = .center
        return imgView
    }()
    
    let searchTxtFieldView: UITextField = {
        let textFieldView = UITextField()
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.placeholder = "어떤 것을 찾고 계신가요?"
        textFieldView.clearButtonMode = .always
        textFieldView.clearsOnBeginEditing = false
        textFieldView.returnKeyType = .done
        return textFieldView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()

    let img1: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "img1")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let img2: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "img2")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let img3: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "img3")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let lbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "심리상담사, 심리워크샵, 힐링상품을 검색해 보세요."
        view.numberOfLines = 0
        view.textColor = .lightGray
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 17)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.addNavi(title: "검색")
        
        let guide = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(searchView)
        self.searchView.addSubview(searchImgView)
        self.searchView.addSubview(searchTxtFieldView)
        self.view.addSubview(containerView)
        self.containerView.addSubview(stackView)
        self.stackView.addArrangedSubview(img1)
        self.stackView.addArrangedSubview(img2)
        self.stackView.addArrangedSubview(img3)
        self.containerView.addSubview(lbl)
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 30),
            searchView.heightAnchor.constraint(equalToConstant: 50),
            searchView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
            searchView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8),
            
            containerView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -15),
            containerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // searchView
        NSLayoutConstraint.activate([
            searchImgView.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchImgView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 8),
            searchImgView.widthAnchor.constraint(equalToConstant: 20),
            searchImgView.heightAnchor.constraint(equalToConstant: 20),
            
            searchTxtFieldView.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchTxtFieldView.leadingAnchor.constraint(equalTo: searchImgView.trailingAnchor, constant: 8),
            searchTxtFieldView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -8),
        ])
        
        // containerView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 70),
            
            img1.widthAnchor.constraint(equalToConstant: 70),

            lbl.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            lbl.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            lbl.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
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
