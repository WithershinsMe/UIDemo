//
//  ViewController.swift
//  Demo
//
//  Created by GK on 2018/6/16.
//  Copyright © 2018年 GK. All rights reserved.
//

import UIKit

class MealsViewController: UIViewController {

    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var mainSegmentedControl: UISegmentedControl! {
        
        didSet {
        mainSegmentedControl.tintColor = UIColor.white
        mainSegmentedControl.backgroundColor = UIColor.white
        
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.gray,NSAttributedStringKey.font:font]
        mainSegmentedControl.setTitleTextAttributes(attributes, for: .normal)
        
        let selectedAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font:font]
        
        mainSegmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        mainSegmentedControl.selectedSegmentIndex = 0;
        }
    }
    
    @IBOutlet weak var animationViewForMain: UIView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl! {
        didSet {
            segmentControl.tintColor = UIColor.white
            segmentControl.backgroundColor = UIColor.white
            
            let font = UIFont.systemFont(ofSize: 10)
            let attributes = [NSAttributedStringKey.foregroundColor: UIColor.gray,NSAttributedStringKey.font:font]
            segmentControl.setTitleTextAttributes(attributes, for: .normal)
            
            let selectedAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font:font]

            segmentControl.setTitleTextAttributes(selectedAttributes, for: .selected)
            segmentControl.selectedSegmentIndex = 0;

        }
    }
    
    private var animationing: Bool = false
    @IBAction func didSelectedSegmentControl(_ sender: UISegmentedControl) {
        
 
        var selectedAnimationView = animationView
        var collectionViewShouldScroll = false
        if sender == segmentControl {
            selectedAnimationView = animationView
            collectionViewShouldScroll = true
        }
        
        if !animationing {
            animationing = true
            UIView.animate(withDuration: 0.4, animations: {
                selectedAnimationView?.frame.origin.x = (sender.frame.width / CGFloat(sender.numberOfSegments)) * CGFloat(sender.selectedSegmentIndex)
            }) { _ in
                
                if collectionViewShouldScroll {
                    let selectedIndexPath = IndexPath(row: sender.selectedSegmentIndex, section: 0)
                    self.collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: false)
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewFlowLayout.minimumLineSpacing = 0

        // Do any additional setup after loading the view, typically from a nib.
        makeNaviagtionBarTransparency()
    }
    func makeNaviagtionBarTransparency() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        
    }
}

extension MealsViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReuseCell", for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if animationing {
            animationing = false
        }else {
            self.segmentControl.selectedSegmentIndex = indexPath.row
            didSelectedSegmentControl(self.segmentControl)
        }
        
    }
    
}




