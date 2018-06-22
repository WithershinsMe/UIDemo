//
//  BaseNavigationViewController.swift
//  Demo
//
//  Created by GK on 2018/6/20.
//  Copyright © 2018年 GK. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self;
    
        // Do any additional setup after loading the view.
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    

}
