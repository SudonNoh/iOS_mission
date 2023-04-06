//
//  SearchVC.swift
//  mission_01
//
//  Created by Sudon Noh on 2023/03/23.
//

import UIKit

class StudyVC: UIViewController {
    
    @IBOutlet weak var roomView: UIView!
    @IBOutlet weak var msgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // roomView 그림자 설정
        self.roomView.layer.shadowColor = UIColor(red: 0.37, green: 0.39, blue: 0.40, alpha: 1.00).cgColor
        self.roomView.layer.shadowOpacity = 0.19
        self.roomView.layer.shadowOffset = CGSize()
        self.roomView.layer.shadowRadius = 15.0
        
        // roomView Radious 설정
        self.roomView.layer.cornerRadius = 12.0
        
        // msgView Radious 설정
        self.msgView.layer.cornerRadius = 21.0
    }
}
