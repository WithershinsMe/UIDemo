//
//  DetailViewController.swift
//  Demo
//
//  Created by GK on 2018/6/16.
//  Copyright © 2018年 GK. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var model: Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = model?.image
    }
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
