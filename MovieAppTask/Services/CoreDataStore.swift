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
        
        try? managedContext.save()
        
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
            
            try? managedContext.save()
            
        } catch _ as NSError {
            print("Error")
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
            
            try? managedContext.save()
            
        } catch _ as NSError {
            print("Error")
        }
    }
    
    func checkIfContains(id: Int) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        
        let moviesId = try? managedContext.fetch(fetchRequest)
        
        for data in moviesId as! [NSManagedObject] {
            let value = data.value(forKey: "movieId") as! NSNumber
            if Int(truncating: value) == id {
                return true
            }
            
        }
        
        return false
    }
    
}
