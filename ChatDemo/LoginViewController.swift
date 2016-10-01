//
//  LoginViewController.swift
//  ChatDemo
//
//  Created by Sriram Rajendran on 1-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  
  
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: Actions
  
  @IBAction func userAnonymousBtn(sender: UIButton) {
    print("userAnonymous")
    
  }
  
  
  
  @IBAction func googlePlusBtn(sender: UIButton) {
    
    print("Google user")
    
  }

}
