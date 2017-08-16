//
//  NotesManager.swift
//  MyNote
//
//  Created by Admin on 12.08.17.
//  Copyright © 2017 com.Dorofeev. All rights reserved.
//

import UIKit
import CoreData

class NotesManager: NSObject {

  var _fetchedResultsController: NSFetchedResultsController? = nil
  var managedObjectContext: NSManagedObjectContext? = nil
  var currentManagedObject: NSManagedObject? = nil
  static var _sharedNotesManager : NotesManager? = nil
  
  var fetchedResultsController: NSFetchedResultsController{
    if _fetchedResultsController != nil {
      return _fetchedResultsController!
    }
    
    let fetchRequest = NSFetchRequest ()
    let entity = NSEntityDescription.entityForName("Note", inManagedObjectContext: self.managedObjectContext!)
    fetchRequest.entity = entity
    _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
    
    return _fetchedResultsController!
    
  }
  
  func addObjectToData(data: NSDictionary){
    let newObject = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: managedObjectContext!)
    newObject.setValue(data.valueForKey("title"), forKey: "title")
    newObject.setValue(data.valueForKey("text"), forKey: "text")
    newObject.setValue(data.valueForKey("dateAdded"), forKey: "dateAdded")
    newObject.setValue(data.valueForKey("dateEdited"), forKey: "dateEdited")
    newObject.setValue(data.valueForKey("image"), forKey: "image")
    saveContext()
  }
  
  func getAllData() ->NSArray{
    let request = NSFetchRequest.init(entityName: "Note")
    let sortBy = NSUserDefaults.standardUserDefaults().valueForKey("sortBy") as! String
    if(sortBy == "title"){
      let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
      request.sortDescriptors = [sortDescriptor]
    }else{
      let sortDescriptor = NSSortDescriptor(key: sortBy, ascending: false)
      request.sortDescriptors = [sortDescriptor]
    }
    
    do {
      let allDataArray = try self.managedObjectContext?.executeFetchRequest(request)
      return allDataArray!
    }
    catch{
      return []
    }
  }
  
  func deleteObject(object: NSManagedObject){
    managedObjectContext?.deleteObject(object)
    saveContext()
  }
  
  func deleteAllObjects(){
    let allData = getAllData()
    for object in allData {
      managedObjectContext?.deleteObject(object as! NSManagedObject)
    }
    saveContext()
  }
  
  static func sharedNotesManager() -> NotesManager{
    if(_sharedNotesManager == nil){
      _sharedNotesManager = NotesManager.init()
    }
    return _sharedNotesManager!
  }
  
  func saveContext () {
    if managedObjectContext!.hasChanges {
      do {
        try managedObjectContext!.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  }
  
}
