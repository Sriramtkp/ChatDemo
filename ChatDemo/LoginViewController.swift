//
//  LoginViewController.swift
//  ChatDemo
//
//  Created by Sriram Rajendran on 1-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

//, GIDSignInDelegate
class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{

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
      
      GIDSignIn.sharedInstance().uiDelegate = self
      GIDSignIn.sharedInstance().delegate = self
      
      GIDSignIn.sharedInstance().clientID = "1018524105473-909lnt89ame6v0v9030mdikdig31elg8.apps.googleusercontent.com"
      
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
  override func viewWillAppear(animated: Bool) {
    
    super.viewWillAppear(animated)
    
    print("FIRAuth.auth()?.currentUser is-----\(FIRAuth.auth()?.currentUser)")
    
    FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
      
      if user != nil {
        print("User is \(user)")
      }else {
        print("User Logged Out")
      }
      
      
    })
    
    
    
    
  }
  
  
//MARK: Actions
  
  @IBAction func userAnonymousBtn(sender: UIButton) {
    print("userAnonymous")
   
      
      Helper.helperObj.userAnonymousBtn()
      
  
    
  }
  

  @IBAction func googlePlusBtn(sender: UIButton) {
    
    print("Google user")
    
    GIDSignIn.sharedInstance().signIn()
    
    
    
    
    
//    let storyboardID = UIStoryboard(name: "Main", bundle: nil)
//    let navVC = storyboardID.instantiateViewControllerWithIdentifier("NavigationVC") as! UINavigationController
//    let shrdInstance = UIApplication.sharedApplication().delegate as! AppDelegate
//    shrdInstance.window?.rootViewController = navVC
    
    
  }

  //MARK : GoogleSignIn
  
  func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
    
    if error != nil {
      print("didSignInForUserError----------\(error.localizedDescription)")
    }
    
    
    print(user.authentication)
    Helper.helperObj.googleLogin(user.authentication)
    
  }
  
  
  
}
