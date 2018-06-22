//
//  IngredientsModel.swift
//  Demo
//
//  Created by GK on 2018/6/18.
//  Copyright © 2018年 GK. All rights reserved.
//

import Foundation


struct MealsModel {
    let image: String
    let title: String
    let subTitle: String
    
    static func allIngredients() -> [MealsModel] {
        return [MealsModel(image: "Rawspinach", title: "Raw spinach", subTitle: "50g"),
                MealsModel(image: "Beets", title: "Beets", subTitle: "175g"),
                MealsModel(image: "Garlic", title: "Garlic", subTitle: "1 clove"),
                MealsModel(image: "Blackpeppre", title: "Black peppre", subTitle: "A timy bit"),
                MealsModel(image: "Mixedherbs", title: "Mixed herbs", subTitle: "1 tsp"),
                MealsModel(image: "Salt", title: "Salt", subTitle: "A timy bit")]
    }
    static func allTools() -> [MealsModel] {
        return [MealsModel(image: "Saucepan", title: "Saucepan", subTitle: "Medium size"),
                MealsModel(image: "Pan", title: "Pan", subTitle: "Medium size"),
                MealsModel(image: "Bakingtray", title: "Baking tray", subTitle: "Glass"),
                MealsModel(image: "Black", title: "Black peppre", subTitle: "A timy bit")
               ]
    }
}
