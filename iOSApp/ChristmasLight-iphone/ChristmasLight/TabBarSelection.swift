//
//  TabBarSelection.swift
//  ChristmasLight
//
//  Created by Shan Jiang on 2016-12-06.
//  Copyright © 2016 Shan Jiang. All rights reserved.
//

import Foundation
import UIKit

class TabBarSelection: UIViewController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            print("selected the first tab bar item")
            //do your stuff
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        print("Its here")
    }
    
}
