//
//  CoreDataManager.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/21/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let sharedManager = CoreDataManager()
    private init() {}
    
    //     lazy var persistentContainer: NSPersistentContainer = {
    //
    //      let container = NSPersistentContainer(name: "MovieAppTask")
    //
    //
    //      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
    //
    //        if let error = error as NSError? {
    //          fatalError("Unresolved error \(error), \(error.userInfo)")
    //        }
    //      })
    //      return container
    //    }()
    
    
    func saveContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }
    
    func insertMovie(id: Int, title: String) -> MovieCoreData? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let movie = MovieCoreData(context: managedContext)
        
        movie.setValue(title, forKey: "title")
        movie.setValue(id, forKey: "id")
        
        do {
            try managedContext.save()
            print("Cool everything is saved")
            return movie as? MovieCoreData
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func delete(movie: MovieCoreData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            managedContext.delete(movie)
        } catch {
            print(error)
        }
        
        do {
            try managedContext.save()
            
        } catch {
            // DO smth
        }
        
    }
    
    func fetchAllMovies() -> [MovieCoreData]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieCoreData")
        
        do {
            let movies = try managedContext.fetch(fetchRequest)
            return movies as? [MovieCoreData]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieCoreData")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let objs = try! managedContext.fetch(fetchRequest)
        
        for case let obj as NSManagedObject in objs {
            managedContext.delete(obj)
            
        }
        
        try! managedContext.save()
        
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<MovieCoreData> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<MovieCoreData>(entityName: "MovieCoreData")
        
        let fetchedResultsController = NSFetchedResultsController<MovieCoreData>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        print("1.NSFetchResultController inited")
        
        return fetchedResultsController
    }()
    
    //    lazy var fetchedResultsController: NSFetchedResultsController<MovieCoreData> = {
    //        let fetchRequest: NSFetchRequest<MovieCoreData> = MovieCoreData.fetchRequest()
    //
    //        let fetchedResultsController = NSFetchedResultsController(
    //            fetchRequest: fetchRequest,
    //            managedContex
    //        )
    //    }()
}
