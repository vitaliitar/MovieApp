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
        print("at indexPath \(index)")
//        print("Cell at: \()")
    }
    
    private let movieService = MovieStore.shared
    private let coreDataService = CoreDataStore.shared
    private let coreDataManager = CoreDataManager.sharedManager
    private var movieId: Int?
    
    @IBOutlet weak var tableFavoritesView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var shouldShowLoadingCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.color = UIColor.green
        activityIndicatorView.startAnimating()
        
        tableFavoritesView.separatorColor = UIColor.green
        
        tableFavoritesView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        //
        tableFavoritesView.delegate = self
        tableFavoritesView.dataSource = self
        //        tableFavoritesView.
        //        tableFavoritesView.
        //        tableFavoritesView.prefetchDataSource = self
        //        coreDataManager.insertMovie(id: 3, title: "Diana")
    }
    func fetchAllPersons(){
        
        /*This class is delegate of fetchedResultsController protocol methods*/
        coreDataManager.fetchedResultsController.delegate = self
        do{
            
            print("2. NSFetchResultController will start fetching :)")
            /*initiate performFetch() call on fetchedResultsController*/
            try coreDataManager.fetchedResultsController.performFetch()
            print("3. NSFetchResultController did end fetching :)")
            
        }catch{
            print(error)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllPersons()
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
        
        //        TODO add movie
        let movie = coreDataManager.fetchedResultsController.object(at: indexPath)
        cell.delegate = self
        cell.indexPath = indexPath
        print("cellforRowAt: \(cell.indexPath)")
        cell.configureFromCoreData(with: movie)
        
        return cell
    }
    
}

extension FavoritesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = coreDataManager.fetchedResultsController.object(at: indexPath)
        
        print(movie.value(forKey: "title"))
        
        
        // segue
        //        performSegue(withIdentifier: "goDetails", sender: nil)
        
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
        
        print("B. NSFetchResultController didChange NSFetchedResultsChangeType \(type.rawValue):)")
        
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableFavoritesView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableFavoritesView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableFavoritesView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableFavoritesView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
            
            
        case .update:
            break
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        /*finally balance beginUpdates with endupdates*/
        tableFavoritesView.endUpdates()
    }
}

//extension FavoritesController: UITableViewDataSourcePrefetching {
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        if indexPaths.contains(where: isLoadingCell) {
//            viewModel.fetchMovies()
//        }
//    }
//}
//
//extension FavoritesController: FavoritesViewModelDelegate {
//
//    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
//        guard let newIndexPathsToReload = newIndexPathsToReload else {
//            activityIndicatorView.stopAnimating()
//            activityIndicatorView.isHidden = true
//
//            tableFavoritesView.isHidden = false
//            tableFavoritesView.reloadData()
//
//            return
//        }
//
//        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
//        tableFavoritesView.reloadRows(at: indexPathsToReload, with: .automatic)
//
//    }
//
//    func onFetchFailed(with reason: String) {
//        activityIndicatorView.stopAnimating()
//
//        let title = "Warning"
//
//        let action = UIAlertAction(title: "OK", style: .default)
//
//        displayAlert(with: title, message: reason, actions: [action])
//
//    }
//}
//
//private extension FavoritesController {
//    func isLoadingCell(for indexPath: IndexPath) -> Bool {
//        return indexPath.row >= viewModel.currentCount
//    }
//
//    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
//        let indexPathsForVisibleRows = tableFavoritesView.indexPathsForVisibleRows ?? []
//        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
//        return Array(indexPathsIntersection)
//    }
//}
