//
//  ViewController.swift
//  Instagram
//
//  Created by 勝良祥吾 on 2018/02/11.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ESTabBarController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTab()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setupTab() {
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home","camera","setting"])
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.15, alpha: 0.8)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 0.9)
        tabBarController.selectionIndicatorHeight = 3
        
        addChildViewController(tabBarController)
        let tabBarView = tabBarController.view!
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
            ])
        tabBarController.didMove(toParentViewController: self)
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        
        tabBarController.setView(homeViewController, at: 0)
        tabBarController.setView(settingViewController, at: 2)
        
        tabBarController.highlightButton(at: 1)
        tabBarController.setAction({
            let imageViewCOntroller = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect")
            self.present(imageViewCOntroller!, animated:  true, completion:  nil)
        }, at: 1)
        
    }

}
