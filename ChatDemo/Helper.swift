//
//  Helper.swift
//  ChatDemo
//
//  Created by Sriram Rajendran on 1-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import UIKit
import GoogleSignIn

class Helper {
  
  static let helperObj = Helper()
  
  
  func userAnonymousBtn() {
    print("userAnonymous")
    
  
      FIRAuth.auth()?.signInAnonymouslyWithCompletion({ (anonyUser: FIRUser?, errorInAuth : NSError?) in
      
      
      if errorInAuth == nil{
        print("AnonUserId---\(anonyUser!.uid)")
        
        self.switchViewControllers()
        
        
        }else{
        
        print("\(errorInAuth!.localizedDescription)")
        
        }
      
        })
    
        }
  

  
  func googleLogin(authentication:GIDAuthentication)  {
    
    
     let credentials = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
    
    FIRAuth.auth()?.signInWithCredential(credentials, completion: { (user: FIRUser?, error: NSError?) in
      
      if error == nil{
        
        self.switchViewControllers()
        
        print(user?.email)
        print(user?.displayName)
        
////        print(error?.localizedDescription)
//        return
        
      }else{
        
//        self.switchViewControllers()
//        
//        print(user?.email)
//        print(user?.displayName)
        
        print(error!.localizedDescription)
      }
      
      
    })
    
    
    
  }
  
  
  func switchViewControllers()  {
    
    let storyboardID = UIStoryboard(name: "Main", bundle: nil)
    let navVC = storyboardID.instantiateViewControllerWithIdentifier("NavigationVC") as! UINavigationController
    
    let shrdInstance = UIApplication.sharedApplication().delegate as! AppDelegate
    
    shrdInstance.window?.rootViewController = navVC
    
    
    
    
  }
  
  
  
}
