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
  

  @IBOutlet weak var noteTitleTextView: UITextView!
  @IBOutlet weak var noteTextTextView: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      if(navigationItem.title == "Edit Note"){
        let dataManager = NotesManager.sharedNotesManager()
        noteTitleTextView.text = dataManager.currentManagedObject?.valueForKey("title") as! String
        noteTextTextView.text = dataManager.currentManagedObject?.valueForKey("text") as! String
      }
      automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func backBarButtonAction(sender: AnyObject) {
    navigationController?.popToRootViewControllerAnimated(true)
  }
  
  @IBAction func saveBarButtonAction(sender: UIBarButtonItem) {
    let dataManager = NotesManager.sharedNotesManager()

    if(navigationItem.title == "Add Note"){
      let noteTitle = noteTitleTextView.text
      let noteText = noteTextTextView.text
      let dateAdded = NSDate()
      let noteDataDictionary = ["title": noteTitle, "text": noteText, "dateAdded": dateAdded, "dateEdited": dateAdded]
      dataManager.addObjectToData(noteDataDictionary)
    }else{
      dataManager.currentManagedObject?.setValue(noteTitleTextView.text, forKey: "title")
      dataManager.currentManagedObject?.setValue(noteTextTextView.text, forKey: "text")
      dataManager.currentManagedObject?.setValue(NSDate(), forKey: "dateEdited")
      dataManager.saveContext()
    }
    navigationController?.popToRootViewControllerAnimated(true)
    
  }


}
