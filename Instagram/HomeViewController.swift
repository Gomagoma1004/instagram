//
//  HomeViewController.swift
//  Instagram
//
//  Created by 勝良祥吾 on 2018/02/11.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillApper")
        
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました")
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postData, at: 0)
                        self.tableView.reloadData()
                    }
                })
                
                postsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました")
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postData.id {
                                index = self.postArray.index(of: post)!
                                break
                            }
                        }
                        
                        self.postArray.remove(at: index)
                        self.postArray.insert(postData, at: index)
                        self.tableView.reloadData()
                    }
                })
                observing = true

            }
        } else {
            
            if observing == true {
                postArray = []
                tableView.reloadData()
                Database.database().reference().removeAllObservers()
                observing = false
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        cell.likeButton.addTarget(self, action: #selector(handleButton(_: forEvent:)), for: .touchUpInside)
        cell.contributionButton.addTarget(self, action: #selector(handleTextField(_: forEvent:)), for: .touchUpInside)
        return cell
    }
    
    @objc func handleTextField(_ sender: UIButton, forEvent event: UIEvent){
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        if let user = Auth.auth().currentUser {
            let postCell = tableView.cellForRow(at: indexPath!) as! PostTableViewCell
            let newComent = postCell.comentTextField.text!
            
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id)
            let coment = "\(String(describing: user.displayName!)): \(newComent)"
            postData.coment.append(coment)
            let coments = ["coment": postData.coment]
            SVProgressHUD.showSuccess(withStatus: "コメントしました")
            postRef.updateChildValues(coments)
        }
    }
    
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました")
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        if let uid = Auth.auth().currentUser?.uid {
            if postData.isLiked {
                var index = -1
                for likeId in postData.likes {
                    if likeId == uid {
                        index = postData.likes.index(of: likeId)!
                        break
                    }
                }
                postData.likes.remove(at: index)
            } else {
                postData.likes.append(uid)
            }
            
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id)
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
