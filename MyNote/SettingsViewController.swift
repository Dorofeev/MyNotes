//
//  SettingsViewController.swift
//  MyNote
//
//  Created by Admin on 16.08.17.
//  Copyright © 2017 com.Dorofeev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

  @IBOutlet weak var deleteAllNotesButton: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let layer = deleteAllNotesButton.layer
      layer.masksToBounds = true;
      layer.cornerRadius = 15;
      layer.borderWidth = 1.0;
      layer.borderColor = UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).CGColor;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func deleteAllNotesAction(sender: AnyObject) {
    NotesManager.sharedNotesManager().deleteAllObjects()
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
