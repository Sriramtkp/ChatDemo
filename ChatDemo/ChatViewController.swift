//
//  ChatViewController.swift
//  ChatDemo
//
//  Created by Sriram Rajendran on 1-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
  
  //vars
  
  var messagesArray = [JSQMessage]()
  
  
  

    override func viewDidLoad() {
        super.viewDidLoad()

      self.senderId = "User1"
      self.senderDisplayName = "Sriram"
      
      self.title = "MessagesViewController"
      self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.redColor()]
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  //MARK: JSQ funcs
  
  override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    
    print(text.capitalizedString)
    
    messagesArray.append(JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text))
    collectionView.reloadData()
    print(messagesArray)
    
  }
  
  override func didPressAccessoryButton(sender: UIButton!) {
    print("AccessoryButton pressed")
    
    let imgpicker = UIImagePickerController()
    imgpicker.delegate = self
    
    self.presentViewController(imgpicker, animated: true, completion: nil)
    
    
  }
  
  //MARK: JSQ's CollectionsView funcs
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return messagesArray.count
    
    
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
    
    
    return cell
    
  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
    
    
    return messagesArray[indexPath.item]
    
  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
    
    let messageBubble = JSQMessagesBubbleImageFactory()
    
    return messageBubble.outgoingMessagesBubbleImageWithColor(UIColor.darkGrayColor())
    
    
    
  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
    
  }
  
  
  
  
  //MARK: Action
  
  
  @IBAction func logoutBtnAction(sender: UIBarButtonItem) {
    
    let storyboardID = UIStoryboard(name: "Main", bundle: nil)
    let loginVC = storyboardID.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
    let shrdInstance = UIApplication.sharedApplication().delegate as! AppDelegate
    shrdInstance.window?.rootViewController = loginVC
    
    
    
  }
  
 
}

//MARK: Extension

extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
    print("image picked up the info\(info)")
    
    let picture = info[UIImagePickerControllerOriginalImage] as? UIImage
    let photo  = JSQPhotoMediaItem(image: picture!)
    messagesArray.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))
    self.dismissViewControllerAnimated(true, completion: nil)
    collectionView.reloadData()
  }
  
  
  
}




