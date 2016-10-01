//
//  ChatViewController.swift
//  ChatDemo
//
//  Created by Sriram Rajendran on 1-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  //MARK: Action
  
  
  @IBAction func logoutBtnAction(sender: UIBarButtonItem) {
    
    let storyboardID = UIStoryboard(name: "Main", bundle: nil)
    let loginVC = storyboardID.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
    let shrdInstance = UIApplication.sharedApplication().delegate as! AppDelegate
    shrdInstance.window?.rootViewController = loginVC
    
    
    
  }
  
  
  
  

}
