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
    
    @IBOutlet var headerImageView:UIImageView!
      
    
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
    
    func makeNaviagtionBarTransparency() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)

    }
    func makeNaviagtionBarDefault() {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
}

extension MealDetailViewController: UICollectionViewDataSource {
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
            
            self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: alpha)
        }
        

    }
}
