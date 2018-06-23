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
    
    @IBAction func didSelectedSegmentControl(_ sender: UISegmentedControl) {
        
 
        var selectedAnimationView = animationView
        var collectionViewShouldScroll = false
        if sender == segmentControl {
            selectedAnimationView = animationView
            collectionViewShouldScroll = true
        }
        
      
        
            UIView.animate(withDuration: 0.4, animations: {
                selectedAnimationView?.frame.origin.x = (sender.frame.width / CGFloat(sender.numberOfSegments)) * CGFloat(sender.selectedSegmentIndex)
            }) { _ in
                
               
            }
            
        if collectionViewShouldScroll {
            let selectedIndexPath = IndexPath(row: sender.selectedSegmentIndex, section: 0)
            self.collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
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
    var selectedCell: MealsCollectionViewCell?
    var selectedImageView: UIImageView?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "MealShowDetail" {
            if let detailVC = segue.destination as? MealDetailViewController{
                if let image = self.selectedImageView?.image {
                    detailVC.model = Model(image: image)
                }
                detailVC.transitioningDelegate = self
            }
        }
        
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
       
//            self.segmentControl.selectedSegmentIndex = indexPath.row
//            didSelectedSegmentControl(self.segmentControl)
       
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? MealsCollectionViewCell
        selectedImageView = selectedCell?.imageView
        performSegue(withIdentifier: "MealShowDetail", sender: nil)
    }
}

extension MealsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var finalFrame: CGRect?
        var snapView: UIView = (self.selectedCell?.imageView)!.snapshotView(afterScreenUpdates: true)!;

        if let toVC = presented as? MealDetailViewController {
            finalFrame = toVC.headerImageView.frame
            snapView = toVC.headerImageView
        }
        let originFrame = selectedCell?.convert(selectedCell?.imageView.frame ?? CGRect.zero, to: self.view)
        //selectedCell?.imageView.alpha = 0;
        
        let transition = PresentAnimationController(originFrame: originFrame!, finalFrame: finalFrame, snapshotView: snapView)
        transition.dismissCompletion = { [weak self] in
            self?.selectedCell?.imageView.alpha = 1;
        }
        transition.originView =  selectedCell?.imageView
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let revealVC = dismissed as? MealDetailViewController else {
            return nil
        }
        if let targetCell = selectedCell {
            let destinationFrame = targetCell.convert(targetCell.imageView.frame, to: self.view)
            
            let snapView = revealVC.headerImageView
            
            let transition = DismissAnimationController(destinationFrame: destinationFrame,snapshotView: snapView);
            targetCell.imageView.isHidden = true;
            transition.dismissCompletion = { [weak self] in
                self?.selectedCell?.imageView.isHidden = false;
            }
            return transition
        }
        return nil
    }
}


