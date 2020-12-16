//
//  MovieStore.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/2/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStore: CoreDataService {
    
    static let shared = CoreDataStore()
    private init() {}
    
    func save(id: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: managedContext)!
        
        let movie = NSManagedObject(entity: entity, insertInto: managedContext)
        
        movie.setValue(id, forKey: "movieId")
        
        do {
            try managedContext.save()
        } catch {
            //            print("Failed saving")
            //            let title = "Error"
            //
            //            let action = UIAlertAction(title: "OK", style: .default)
            //
            //            displayAlert(with: title, message: "Failed saving", actions: [action])
        }
    }
    
    func retrieve() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        let result = try? managedContext.fetch(fetchRequest)
        
        for data in result as! [NSManagedObject] {
            print(data.value(forKey: "movieId")!)
        }
        
    }
    
    func deleteFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        do {
            let moviesId = try managedContext.fetch(fetchRequest)
            
            for data in moviesId {
                managedContext.delete(data as! NSManagedObject)
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                //
                //                let title = "Error"
                //
                //                let action = UIAlertAction(title: "OK", style: .default)
                //
                //                displayAlert(with: title, message: "Could not save", actions: [action])
                
                print("Could not save, \(error), \(error.userInfo)")
            }
            
        } catch _ as NSError {
            
            //            let title = "Error"
            //
            //            let action = UIAlertAction(title: "OK", style: .default)
            //
            //            displayAlert(with: title, message: "Could not save", actions: [action])
            
        }
    }
    
    func deleteById(id: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        do {
            let moviesId = try managedContext.fetch(fetchRequest)
            
            for data in moviesId as! [NSManagedObject] {
                let value = data.value(forKey: "movieId") as! NSNumber
                if Int(truncating: value) == id {
                    managedContext.delete(data)
                }
                
            }
            
            do {
                try managedContext.save()
            } catch _ as NSError {
                
                //                let title = "Error"
                //
                //                let action = UIAlertAction(title: "OK", style: .default)
                //
                //                displayAlert(with: title, message: "Could not save", actions: [action])
            }
            
        } catch _ as NSError {
            
            //            let title = "Error"
            //
            //            let action = UIAlertAction(title: "OK", style: .default)
            //
            //            displayAlert(with: title, message: "Failed saving", actions: [action])
        }
    }
    
    func checkIfContains(id: Int) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        do {
            let moviesId = try managedContext.fetch(fetchRequest)
            
            for data in moviesId as! [NSManagedObject] {
                let value = data.value(forKey: "movieId") as! NSNumber
                if Int(truncating: value) == id {
                    return true
                }
                
            }
            
        } catch _ as NSError {
            
            //            let title = "Error"
            //
            //            let action = UIAlertAction(title: "OK", style: .default)
            //
            //            displayAlert(with: title, message: "Failed to get data", actions: [action])
        }
        return false
    }
}
