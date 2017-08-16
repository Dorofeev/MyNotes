//
//  NoteDetailViewController.swift
//  MyNote
//
//  Created by Admin on 12.08.17.
//  Copyright © 2017 com.Dorofeev. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var noteImageButton: UIButton!
  
  @IBOutlet weak var noteTitleTextView: UITextView!
  @IBOutlet weak var noteTextTextView: UITextView!
  
  var isImageSetted: Bool = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
      if(navigationItem.title == "Edit Note"){
        let dataManager = NotesManager.sharedNotesManager()
        noteTitleTextView.text = dataManager.currentManagedObject?.valueForKey("title") as! String
        noteTextTextView.text = dataManager.currentManagedObject?.valueForKey("text") as! String
        if(dataManager.currentManagedObject?.valueForKey("image") != nil && dataManager.currentManagedObject?.valueForKey("image")?.length > 0){
          let imageData = dataManager.currentManagedObject?.valueForKey("image") as! NSData
          noteImageButton.setBackgroundImage(UIImage(data: imageData), forState: UIControlState.Normal)
          isImageSetted = true
        }
        else{
          isImageSetted = false
        }
      }
      automaticallyAdjustsScrollViewInsets = false


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func setImage(image: UIImage){
    noteImageButton.setBackgroundImage(image, forState: UIControlState.Normal)
    isImageSetted = true
  }
    
  @IBAction func imageButtonAction(sender: AnyObject) {
    
    let chooseImageMenu = UIAlertController(title: "Take image from", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
    let fromGalleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) -> Void in
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
      imagePicker.delegate = self
      self.presentViewController(imagePicker, animated:true, completion: nil)
      
      
    })
    
    let fromCamera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) -> Void in
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
      imagePicker.delegate = self
      self.presentViewController(imagePicker, animated:true, completion: nil)
    })
    
    chooseImageMenu.addAction(fromGalleryAction)
    chooseImageMenu.addAction(fromCamera)
    
    if(isImageSetted){
      let deleteImage = UIAlertAction(title: "Delete Image", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) -> Void in
        self.noteImageButton.setBackgroundImage(UIImage(named: "noImage"), forState: UIControlState.Normal)
        self.isImageSetted = false
      })
      chooseImageMenu.addAction(deleteImage)
    }
    
    
    self.presentViewController(chooseImageMenu, animated: true, completion: nil)

  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    let scaleSize = CGSizeMake(100, 100)
    UIGraphicsBeginImageContext(scaleSize)
    pickedImage.drawInRect(CGRectMake(0, 0, 100, 100))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    picker.dismissViewControllerAnimated(true, completion: nil)
    self.setImage(resizedImage)
    
  }

  
  @IBAction func backBarButtonAction(sender: AnyObject) {
    navigationController?.popToRootViewControllerAnimated(true)
  }
  
  @IBAction func deleteObjectBarButtonAction(sender: AnyObject) {
    let dataManager = NotesManager.sharedNotesManager()
    dataManager.deleteObject(dataManager.currentManagedObject!)
    navigationController?.popToRootViewControllerAnimated(true)
  }
  
  @IBAction func saveBarButtonAction(sender: UIBarButtonItem) {
    let dataManager = NotesManager.sharedNotesManager()

    if(navigationItem.title == "Add Note"){
      
      let noteTitle = noteTitleTextView.text
      let noteText = noteTextTextView.text
      let dateAdded = NSDate()
      var imageData: NSData = NSData()
      
      if(isImageSetted){
        imageData = UIImagePNGRepresentation(noteImageButton.backgroundImageForState(UIControlState.Normal)!)!
      }

      let noteDataDictionary = ["title": noteTitle, "text": noteText, "dateAdded": dateAdded, "dateEdited": dateAdded, "image": imageData]
      dataManager.addObjectToData(noteDataDictionary)
      
    }else{
      
      if(isImageSetted){
        
        let imageData = UIImagePNGRepresentation(noteImageButton.backgroundImageForState(UIControlState.Normal)!)
        dataManager.currentManagedObject?.setValue(imageData, forKey: "image")

      }
      else {
        
        dataManager.currentManagedObject?.setValue(NSData(), forKey: "image")
        
      }
      
      dataManager.currentManagedObject?.setValue(noteTitleTextView.text, forKey: "title")
      dataManager.currentManagedObject?.setValue(noteTextTextView.text, forKey: "text")
      dataManager.currentManagedObject?.setValue(NSDate(), forKey: "dateEdited")
      dataManager.saveContext()
      
    }
    navigationController?.popToRootViewControllerAnimated(true)
    
  }


}
