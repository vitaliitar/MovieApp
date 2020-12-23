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
    
    func saveContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insertMovie(movieData: Movie) -> MovieCoreData? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let movie = MovieCoreData(context: managedContext)
        
        movie.setValue(movieData.id, forKey: "id")
        movie.setValue(movieData.title, forKey: "title")
        movie.setValue(movieData.posterPath, forKey: "posterPath")
        movie.setValue(movieData.overview, forKey: "overview")
        movie.setValue(movieData.voteAverage, forKey: "voteAverage")
        movie.setValue(movieData.voteCount, forKey: "voteCount")
        movie.setValue(movieData.releaseDate, forKey: "releaseDate")
        
        do {
            try managedContext.save()
            print("Cool everything is saved")
            return movie
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func deleteById(movieId: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieCoreData")
        
        do {
            let movies = try managedContext.fetch(fetchRequest)
            
            for data in movies as! [NSManagedObject] {
                let valueId = data.value(forKey: "id") as! Int
                
                if valueId == movieId {
                    managedContext.delete(data)
                }
                
            }
            
            try? managedContext.save()
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
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController<MovieCoreData>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        print("1.NSFetchResultController inited")
        
        return fetchedResultsController
    }()
}
