//
//  MealDetailViewController.swift
//  Demo
//
//  Created by GK on 2018/6/16.
//  Copyright © 2018年 GK. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 216.0
let offset_B_LabelHeader:CGFloat = 30
let distance_W_LabelHeader:CGFloat = 15

class MealDetailViewController: UIViewController {
    
    @IBOutlet weak var toolsCollectionView: UICollectionView!
    @IBOutlet weak var IngredientsCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var navigationView: UINavigationBar!
    @IBOutlet var headerImageView:UIImageView!
    
    var selectedCell: DetailCollectionViewCell?
    var selectedImageView: UIImageView?
    
    var model: Model?
    
    
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.layer.cornerRadius = 20
            bottomView.layer.borderColor = UIColor.black.cgColor
            bottomView.clipsToBounds = true
        }
    }
    var statusBarView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeNaviagtionBarTransparency()
        statusBarView =  UIView(frame: CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        statusBarView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        
        self.view.addSubview(statusBarView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        headerImageView.image = model?.image
    }
    func makeNaviagtionBarTransparency() {
        self.navigationView.setBackgroundImage(UIImage(), for: .default)
        self.navigationView.shadowImage = UIImage()
        self.navigationView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)

    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    func makeNaviagtionBarDefault() {
        self.navigationView.setBackgroundImage(nil, for: .default)
        self.navigationView.shadowImage = nil
        self.navigationView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "Detail" {
            if let detailVC = segue.destination as? DetailViewController{
                if let image = self.selectedImageView?.image {
                    detailVC.model = Model(image: image)
                }
                detailVC.transitioningDelegate = self
            }
        }
        
    }
}

extension MealDetailViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == IngredientsCollectionView {
            return MealsModel.allIngredients().count
        }else if collectionView == toolsCollectionView {
            return MealsModel.allTools().count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let meal: MealsModel
        let cell: UICollectionViewCell
        
        if collectionView == IngredientsCollectionView {
            meal = MealsModel.allIngredients()[indexPath.row]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath)
        }else if collectionView == toolsCollectionView {
            meal = MealsModel.allTools()[indexPath.row]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolsCell", for: indexPath)

        }else {
            cell = UICollectionViewCell()
            meal = MealsModel(image: "", title: "", subTitle: "")
        }
        
        if let imageView = cell.viewWithTag(2001) as? UIImageView, let title = cell.viewWithTag(2002) as? UILabel, let subTitle = cell.viewWithTag(2003) as? UILabel {
            imageView.image = UIImage(named: meal.image)
            title.text = meal.title
            subTitle.text = meal.subTitle
        }
        return cell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? DetailCollectionViewCell
        selectedImageView = selectedCell?.imageView
        performSegue(withIdentifier: "Detail", sender: nil)
    }
}

extension MealDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.scrollView == scrollView {
            let offset = scrollView.contentOffset.y
            var headerTransform = CATransform3DIdentity
            
            if offset < 0 {
                let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
                let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0
                headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
                headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
                
                headerView.layer.transform = headerTransform
                
            }else {
                headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -(offset)), 0)
                
                let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
                headerLabel.layer.transform = labelTransform
                
            }
            
            headerView.layer.transform = headerTransform
            
            let alpha = offset / ( headerView.frame.size.height - 84)
            self.statusBarView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: alpha)
            
            self.navigationView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: alpha)
        }
        

    }
}

extension MealDetailViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var finalFrame: CGRect?

        if let toVC = presented as? MealDetailViewController {
            finalFrame = toVC.headerImageView.frame
        }
        let originFrame = selectedCell?.convert(selectedCell?.imageView.frame ?? CGRect.zero, to: self.view)
        selectedCell?.imageView.isHidden = true;
        
        let transition = PresentAnimationController(originFrame: originFrame!, finalFrame: finalFrame, snapshotView: nil)
        transition.dismissCompletion = { [weak self] in
            self?.selectedCell?.imageView.isHidden = false;
        }
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let revealVC = dismissed as? DetailViewController else {
            return nil
        }
        if let targetCell = selectedCell {
            let destinationFrame = targetCell.convert(targetCell.imageView.frame, to: self.view)
            
            let snapView = revealVC.imageView
            
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
