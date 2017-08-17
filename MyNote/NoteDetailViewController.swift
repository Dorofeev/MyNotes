//
//  NoteDetailViewController.swift
//  MyNote
//
//  Created by Admin on 12.08.17.
//  Copyright © 2017 com.Dorofeev. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailViewController: UIViewController {
  
  @IBOutlet weak var deleteNoteBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var noteImageButton: UIButton!
  @IBOutlet weak var noteTitleTextView: UITextView!
  @IBOutlet weak var noteTextTextView: UITextView!
  
  @IBOutlet weak var noteImageWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var noteImageHeightContraint: NSLayoutConstraint!
  
  private var isImageSetted: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if navigationItem.title == "Edit Note" {
      deleteNoteBarButtonItem.enabled = true
      let dataManager = NotesManager.sharedNotesManager()
      noteTitleTextView.text = dataManager.currentManagedObject?.valueForKey("title") as! String
      noteTextTextView.text = dataManager.currentManagedObject?.valueForKey("text") as! String
      if dataManager.currentManagedObject?.valueForKey("image") != nil && dataManager.currentManagedObject?.valueForKey("image")?.length > 0 {
        let imageData = dataManager.currentManagedObject?.valueForKey("image") as! NSData
        noteImageButton.setBackgroundImage(UIImage(data: imageData), forState: UIControlState.Normal)
        isImageSetted = true
      }
      else{
        isImageSetted = false
      }
    }
    automaticallyAdjustsScrollViewInsets = false
    
    initContraints()
  }
  
  private func setImage(image: UIImage){
    noteImageButton.setBackgroundImage(image, forState: UIControlState.Normal)
    isImageSetted = true
  }
  
  private func initContraints() {
    let screenWidth = self.view.bounds.width
    if screenWidth == 375.0 {
      noteImageHeightContraint.constant = 135.0
      noteImageWidthConstraint.constant = 135.0
    }else if screenWidth > 400{
      noteImageHeightContraint.constant = 175.0
      noteImageWidthConstraint.constant = 175.0
    }
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
    
    if isImageSetted {
      let deleteImage = UIAlertAction(title: "Delete Image", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) -> Void in
        self.noteImageButton.setBackgroundImage(UIImage(named: "noImage"), forState: UIControlState.Normal)
        self.isImageSetted = false
      })
      chooseImageMenu.addAction(deleteImage)
    }
    self.presentViewController(chooseImageMenu, animated: true, completion: nil)
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
    if navigationItem.title == "Add Note" {
      let noteTitle = noteTitleTextView.text
      let noteText = noteTextTextView.text
      let dateAdded = NSDate()
      var imageData: NSData = NSData()
      if isImageSetted {
        imageData = UIImagePNGRepresentation(noteImageButton.backgroundImageForState(UIControlState.Normal)!)!
      }
      let noteDataDictionary = ["title": noteTitle, "text": noteText, "dateAdded": dateAdded, "dateEdited": dateAdded, "image": imageData]
      dataManager.addObjectToData(noteDataDictionary)
    }else{
      if isImageSetted {
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

// MARK: -UIImagePickerControllerDelegate

extension NoteDetailViewController: UIImagePickerControllerDelegate{
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    let scaleSize = CGSizeMake(200, 200)
    UIGraphicsBeginImageContext(scaleSize)
    pickedImage.drawInRect(CGRectMake(0, 0, 200, 200))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    picker.dismissViewControllerAnimated(true, completion: nil)
    self.setImage(resizedImage)
  }
}

// MARK: -UINavigationControllerDelegate

extension NoteDetailViewController: UINavigationControllerDelegate{
  
}
