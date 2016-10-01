//
//  LoginViewController.swift
//  ChatDemo
//
//  Created by Sriram Rajendran on 1-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  //MARK: outlets
  
  
  @IBOutlet weak var loginAnonymOutlet: UIButton!
  
  
  @IBOutlet weak var gooleBtnOutlet: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      self.loginAnonymOutlet.layer.borderWidth = 2.0
      self.loginAnonymOutlet.layer.borderColor = UIColor.redColor().CGColor
      self.loginAnonymOutlet.layer.cornerRadius = self.loginAnonymOutlet.frame.size.height/2
      
      
      self.gooleBtnOutlet.layer.borderWidth = 2.0
      self.gooleBtnOutlet.layer.borderColor = UIColor.redColor().CGColor
      self.gooleBtnOutlet.layer.cornerRadius = self.gooleBtnOutlet.frame.size.height/2
      
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
