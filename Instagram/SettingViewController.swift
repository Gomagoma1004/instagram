//
//  SettingViewController.swift
//  Instagram
//
//  Created by 勝良祥吾 on 2018/02/11.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ESTabBarController
import SVProgressHUD

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text {
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力してください")
                return
            }
            
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges{ error in
                    if let error = error {
                        print("DEBUG_PRINT: " + error.localizedDescription)
                    }
                    print("DEBUG_PRINT: \(String(describing: user.displayName))の設定に成功しました")
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            } else {
                print("DEBUG_PRINT: displayNmaeの設定に失敗しました")
            }
        }
        self.view.endEditing(true)
    }
    
    @IBAction func handleLogoutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
        
    }
    

}
