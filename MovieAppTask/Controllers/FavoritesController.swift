//
//  FavoritesController.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/14/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit
import CoreData

class FavoritesController: UIViewController, TableViewCellDelegate, AlertDisplayer {
    func favoriteTapped(at index: IndexPath) {
        
        let movie = coreDataManager.fetchedResultsController.object(at: index)
        
        let containsInFavorite = coreDataService.checkIfContains(id: movie.id)
        
        if containsInFavorite {
            
            coreDataService.deleteById(id: movie.id)
            coreDataManager.deleteById(movieId: movie.id)
            
        }
        tableFavoritesView.reloadData()
        
    }
    
    private let movieService = MovieStore.shared
    private let coreDataService = CoreDataStore.shared
    private let coreDataManager = CoreDataManager.sharedManager
    private var movieId: Int?
    
    @IBOutlet weak var tableFavoritesView: UITableView!
    
    private var shouldShowLoadingCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableFavoritesView.separatorColor = UIColor.green
        
        tableFavoritesView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        
        tableFavoritesView.delegate = self
        tableFavoritesView.dataSource = self
        
    }
    func fetchAllMovies() {
        
        coreDataManager.fetchedResultsController.delegate = self
        do {
            
            try coreDataManager.fetchedResultsController.performFetch()
            
        } catch {
            print(error)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailsViewController {
            let vc = segue.destination as? DetailsViewController
            vc?.movieId = movieId
        }
    }
    
}

extension FavoritesController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = coreDataManager.fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        
        let movie = coreDataManager.fetchedResultsController.object(at: indexPath)
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.configureFromCoreData(with: movie)
        
        return cell
    }
    
}

extension FavoritesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = coreDataManager.fetchedResultsController.object(at: indexPath)
        
        movieId = movie.id
        
        performSegue(withIdentifier: "goDetails", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension FavoritesController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("NS controllerWillChangeContent :")
        
        tableFavoritesView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableFavoritesView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableFavoritesView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath {
                tableFavoritesView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableFavoritesView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .update:
            break
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableFavoritesView.endUpdates()
    }
}
