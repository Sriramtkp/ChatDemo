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
import FirebaseStorage
import FirebaseAuth



class ChatViewController: JSQMessagesViewController {
  
  //vars
  
  var messagesArray = [JSQMessage]()
  
  var messageChildRef = FIRDatabase.database().reference().child("messages")
  
  

    override func viewDidLoad() {
        super.viewDidLoad()

      let currentUser = FIRAuth.auth()?.currentUser
      
      if currentUser?.anonymous == true {
        
        self.senderDisplayName = "anonymous"
        
      }else {
        self.senderDisplayName = "\(currentUser?.displayName!)"
        
      }
      
//      let currentUserID = FIRAuth.auth()?.currentUser
//      print("currentUser--- \(currentUserID)")
//      
//      self.senderId = currentUser?.uid
//      self.senderDisplayName = "Sriram"
      
      
      
      self.senderId = currentUser?.uid
//      self.senderDisplayName = "Sriram"
      
      self.title = self.senderDisplayName
      self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.redColor()]
      

//      let rootFBRef = FIRDatabase.database().reference()
//      print("rootFBRef=== \(rootFBRef)")
//      
//      let messageChildRef = rootFBRef.child("messages")
//      print(messageChildRef)
      
      //to upload to Firebase
//      messageChildRef.setValue("sriramMacBook")
//      messageChildRef.childByAutoId().setValue("First Message")
//      messageChildRef.childByAutoId().setValue("Second Message")
      
      //to retrieve from firebase  with FIRDataEventType.Value will get all he value
//      messageChildRef.observeEventType(FIRDataEventType.Value) { (snapShot: FIRDataSnapshot) in
//        if let dictOneString = snapShot.value as? String{
//                    print("one message string \(dictOneString)")
//          
//                  }
//      
//        if let dict = snapShot.value as? NSDictionary {
//          print(dict)
//        }
//      
//      
//      }
      
      //------ to retieve with FIRDataEventType.ChildAddedto get only one string
//      messageChildRef.observeEventType(FIRDataEventType.ChildAdded) { (snapShot: FIRDataSnapshot) in
//        if let dictOneString = snapShot.value as? String{
//          print("one message string \(dictOneString)")
//          
//        }
//        
//        if let dict = snapShot.value as? NSDictionary {
//          print(dict)
//        }
//        
//        
//      }
      
      observeMessage()
//      observeUsers()
      
      
 //viewDidload
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

  //MARL : observerFunc
  
  func observeUsers(id: String) {
  
    
FIRDatabase.database().reference().child("users").child(id).observeEventType(.Value, withBlock: { (snapShot) in
  
  print(snapShot.value)
  
  if let dict = snapShot.value as? [String : AnyObject]{
    
    
    print("dict in observeUsers--- \(dict)")
  }
  
  }
  
    )
    
    
    
    
  }
  
  
  
  func observeMessage() {
  
    
    //------ to retieve with FIRDataEventType.ChildAddedto get only one string
          messageChildRef.observeEventType(FIRDataEventType.ChildAdded) { (snapShot: FIRDataSnapshot) in
            print("snapShot.value -----------\(snapShot.value)")
            
            if let dict = snapShot.value as? [String : AnyObject] {
              
              
               let  mediaTypeVar = dict["MediaType"] as! String
              print(mediaTypeVar)
              
               let  senderIdVar = dict["senderId"] as! String
              
             let  senderNameVar = dict["senderName"] as! String
              
              
              self.observeUsers(self.senderId)
              
              if mediaTypeVar == "TEXT"{
                let textVar = dict["text"] as? String
                 self.messagesArray.append(JSQMessage(senderId: senderIdVar, displayName: senderNameVar, text: textVar))
                
                
              } else if mediaTypeVar == "PHOTO" {
                
                
                let photoVar = dict["fileUrl"] as! String
                
                let dataUrl = NSData(contentsOfURL: NSURL(string: photoVar)!)
                
                let picture = UIImage(data: dataUrl!)
                let photo = JSQPhotoMediaItem(image: picture)

                
                  self.messagesArray.append(JSQMessage(senderId: senderIdVar, displayName: senderNameVar, media: photo))
                
                
                if self.senderId == self.senderId {
                  photo.appliesMediaViewMaskAsOutgoing =  true
                  
                }else{
                  photo.appliesMediaViewMaskAsOutgoing = false
                }
                
                
              
              } else if mediaTypeVar == "VIDEO" {
                
                
                let fileUrl = dict["fileUrl"] as! String
                
                let dataUrl = NSURL(string: fileUrl)
                
                let videoItem = JSQVideoMediaItem(fileURL: dataUrl!, isReadyToPlay: true)
                
                

                 self.messagesArray.append(JSQMessage(senderId: senderIdVar, displayName: senderNameVar, media: videoItem))
                
                
                if self.senderId == self.senderId {
                  videoItem.appliesMediaViewMaskAsOutgoing =  true
                  
                }else{
                  videoItem.appliesMediaViewMaskAsOutgoing = false
                }
                
                
                
              }
              
              
              
            
                self.collectionView.reloadData()
                print(self.messagesArray)

             
             }

          }

    //observeMessage
      }
  
  //MARK: JSQ funcs
  
  override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    
//    print(text.capitalizedString)
    
//
  
    let newMessage = messageChildRef.childByAutoId()
    let messageData = ["text": text,"senderId": senderId,  "senderName": senderDisplayName, "MediaType" : "TEXT" ]
    
    newMessage.setValue(messageData)
    
    
    
    
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
    
    let msgIndxPath = messagesArray[indexPath.item]
    let messageBubble = JSQMessagesBubbleImageFactory()

    
    if msgIndxPath.senderId == self.senderId {
      return messageBubble.outgoingMessagesBubbleImageWithColor(UIColor.darkGrayColor())

    }else{
      return messageBubble.outgoingMessagesBubbleImageWithColor(UIColor.blueColor())

    }
    
    
    
    
    
    
    
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
    
    
//    print("FIRAuth.auth()?.currentUser is-----\(FIRAuth.auth()?.currentUser)")
    do {
      try FIRAuth.auth()?.signOut()
      
      
    }catch let error {
      
      print(error)
    }
    
    
    let storyboardID = UIStoryboard(name: "Main", bundle: nil)
    let loginVC = storyboardID.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
    let shrdInstance = UIApplication.sharedApplication().delegate as! AppDelegate
    shrdInstance.window?.rootViewController = loginVC
    
    
  }
  
  
  func sendMedia(picture: UIImage?, video: NSURL?)  {
    
    print("pictureiiiiiiiiiiis \(picture)")
    print(video)
    print(FIRStorage.storage().reference())
    
    //"\(FIRAuth.auth()?.currentUser!.uid) this will give userID
    
    if let picture = picture {
      
      let filePath = "\(FIRAuth.auth()?.currentUser!)/\(NSDate.timeIntervalSinceReferenceDate())"
      print("filepath-------\(filePath)")
      
      let data = UIImageJPEGRepresentation(picture, 1)
      let metaData = FIRStorageMetadata()
      metaData.contentType = "image/jpg"
      FIRStorage.storage().reference().child(filePath).putData(data!, metadata: metaData) { (metadata, error) in
        
        if error != nil{
          print(error?.localizedDescription)
          return
          
        }
        print("MetaData is \(metaData)")
        
        let fileUrl = metaData.downloadURLs![0].absoluteString
        
        let newMsg = self.messageChildRef.childByAutoId()
        
        let messageData = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName" : self.senderDisplayName, "MediaType": "PHOTO"]
        newMsg.setValue(messageData)
        
        
      }
      

    }else if let video = video {
      
      let filePath = "\(FIRAuth.auth()?.currentUser!)/\(NSDate.timeIntervalSinceReferenceDate())"
      print("filepath-------\(filePath)")
      
      let data = NSData(contentsOfURL: video)
      let metaDataFIRS = FIRStorageMetadata()
      metaDataFIRS.contentType = "video/mp4"
      FIRStorage.storage().reference().child(filePath).putData(data!, metadata: metaDataFIRS) { (metadata, error) in
        
        if error != nil{
          print(error?.localizedDescription)
          return
          
        }
        print("MetaData is \(metaDataFIRS)")
        
        let fileUrl = metaDataFIRS.downloadURLs![0].absoluteString
        
        let newMsg = self.messageChildRef.childByAutoId()
        
        let messageData = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName" : self.senderDisplayName, "MediaType": "VIDEO"]
        newMsg.setValue(messageData)

      
    }
    
    
   
    
   //sendMedia
   }
  
  
 
}
}
//MARK: Extension

extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
//    print("image picked up the info\(info)")
    
    if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
    
//      let photo  = JSQPhotoMediaItem(image: picture)
//    messagesArray.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))
      sendMedia(picture, video: nil)
     
    }
    else if let video = info[UIImagePickerControllerMediaURL] as? NSURL {
      
//      let videoItem = JSQVideoMediaItem(fileURL: video, isReadyToPlay: true)
//      messagesArray.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: videoItem))
      
      sendMedia(nil, video: video)
    }
    
     self.dismissViewControllerAnimated(true, completion: nil)
    collectionView.reloadData()
  }
  
  
  
}




