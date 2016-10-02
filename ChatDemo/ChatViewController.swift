//
//  ChatViewController.swift
//  ChatDemo
//
//  Created by Sriram Rajendran on 1-10-16.
//  Copyright © 2016 Sriram Rajendran. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import FirebaseDatabase
import Firebase


class ChatViewController: JSQMessagesViewController {
  
  //vars
  
  var messagesArray = [JSQMessage]()
  
  
  

    override func viewDidLoad() {
        super.viewDidLoad()

      self.senderId = "User1"
      self.senderDisplayName = "Sriram"
      
      self.title = "MessagesViewController"
      self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.redColor()]
      

      let rootFBRef = FIRDatabase.database().reference()
      print("rootFBRef=== \(rootFBRef)")
      
      let messageChildRef = rootFBRef.child("messages")
      print(messageChildRef)
      

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: TextDelegate
  
  func endListeningForKeyboard()  {
    self.view.endEditing(true)

  }
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    
    self.view.endEditing(true)
    
    return true
  }

  
  //MARK: JSQ funcs
  
  override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    
//    print(text.capitalizedString)
    
    messagesArray.append(JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text))
    collectionView.reloadData()
//    print(messagesArray)
    
    
    self.finishSendingMessage() //to emptifiy the textField
    
  }
  
  override func didPressAccessoryButton(sender: UIButton!) {
    print("AccessoryButton pressed")
    
    let actionSheet = UIAlertController(title: "Media Message", message: "Choose Media", preferredStyle: .ActionSheet)
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction) in
      
    }
    
    let photoAction = UIAlertAction(title: "Photos", style: .Default) { (alert: UIAlertAction) in
      self.getMedia(kUTTypeImage)
      
    }
    
    let videoAction = UIAlertAction(title: "Videos", style: .Default) { (alert: UIAlertAction) in
      
      self.getMedia(kUTTypeMovie)
      
    }
    
        actionSheet.addAction(photoAction)
    actionSheet.addAction(videoAction)
    actionSheet.addAction(cancelAction)
    self.presentViewController(actionSheet, animated: true, completion: nil)
    
  }
  
  //MARK: getMediaFromImagePicker
  func getMedia(type: CFString) {
    
    print(type)
    let imgpicker = UIImagePickerController()
        imgpicker.delegate = self
//    let mediaImage = [mediaType as String]
    
    
    
     imgpicker.mediaTypes = [type as String]
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
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
    
    print("didTapMessageBubbleAtIndexPath------\(indexPath.item)")
    
    let message  = messagesArray[indexPath.item]
    if message.isMediaMessage {
      
      if let url = message.media as? JSQVideoMediaItem{
        
      let player = AVPlayer(URL: url.fileURL)
        
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        
      
      self.presentViewController(playerVC, animated: true, completion: nil)
      }

    }
    
    
    
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
    
//    print("image picked up the info\(info)")
    
    if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
    
      let photo  = JSQPhotoMediaItem(image: picture)
    messagesArray.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))
      
     
    }
    else if let video = info[UIImagePickerControllerMediaURL] as? NSURL {
      
      let videoItem = JSQVideoMediaItem(fileURL: video, isReadyToPlay: true)
      messagesArray.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: videoItem))
      
      
    }
    
     self.dismissViewControllerAnimated(true, completion: nil)
    collectionView.reloadData()
  }
  
  
  
}




