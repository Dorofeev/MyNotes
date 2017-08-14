//
//  ViewController.swift
//  MyNote
//
//  Created by Admin on 11.08.17.
//  Copyright © 2017 com.Dorofeev. All rights reserved.
//

import UIKit
import CoreData


class MyNotesViewController: UITableViewController{
  
  
  @IBOutlet var notesTableView: UITableView!
  
  var notesArray: NSArray! = nil
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
  
  override func viewDidAppear(animated: Bool) {
    notesTableView.reloadData()
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if(segue.identifier == "Edit"){
      let detailsViewController = segue.destinationViewController
      detailsViewController.navigationItem.title = "Edit Note"
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    let dataManager = NotesManager.sharedNotesManager()
    notesArray = dataManager.getAllData()
    return notesArray.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    var cell = tableView.dequeueReusableCellWithIdentifier("noteCell")
    if((cell == nil)){
      cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "noteCell")
    }
    
    cell?.textLabel?.text = notesArray[indexPath.row].valueForKey("title") as? String
    return cell!
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    NotesManager.sharedNotesManager().currentManagedObject = notesArray.objectAtIndex(indexPath.row) as? NSManagedObject
  }


}


  
  
  


