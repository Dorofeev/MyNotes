//
//  SettingsViewController.swift
//  MyNote
//
//  Created by Admin on 16.08.17.
//  Copyright © 2017 com.Dorofeev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  @IBOutlet weak var sortBySegementedControl: UISegmentedControl!
  @IBOutlet weak var deleteAllNotesButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    switch(NSUserDefaults.standardUserDefaults().valueForKey("sortBy") as! String){
    case "title": sortBySegementedControl.selectedSegmentIndex = 0
    case "dateEdited": sortBySegementedControl.selectedSegmentIndex = 1
    case "dateAdded": sortBySegementedControl.selectedSegmentIndex = 2
    default: break
    }
    
    let layer = deleteAllNotesButton.layer
    layer.masksToBounds = true;
    layer.cornerRadius = 15;
    layer.borderWidth = 1.0;
    layer.borderColor = UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).CGColor;
  }
  
  @IBAction func sortByDidChange(sender: AnyObject) {
    switch(sortBySegementedControl.selectedSegmentIndex){
    case 0: NSUserDefaults.standardUserDefaults().setValue("title", forKey: "sortBy")
    case 1: NSUserDefaults.standardUserDefaults().setValue("dateEdited", forKey: "sortBy")
    case 2: NSUserDefaults.standardUserDefaults().setValue("dateAdded", forKey: "sortBy")
    default: break
    }
  }
  
  @IBAction func deleteAllNotesAction(sender: AnyObject) {
    NotesManager.sharedNotesManager().deleteAllObjects()
    navigationController?.popToRootViewControllerAnimated(true)
  }
}
