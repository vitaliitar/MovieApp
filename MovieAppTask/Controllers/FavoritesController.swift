//
//  FavoritesController.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/14/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit
import CoreData

class FavoritesController: UIViewController, AlertDisplayer {
    
    private let movieService = MovieStore.shared
    private let coreDataService = CoreDataStore.shared
    private var movieId: Int?
    
    private var viewModel: FavoritesViewModel!
    
    @IBOutlet weak var tableFavoritesView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var shouldShowLoadingCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.color = UIColor.green
        activityIndicatorView.startAnimating()
        
        tableFavoritesView.isHidden = true
        tableFavoritesView.separatorColor = UIColor.green
        
        tableFavoritesView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        
        tableFavoritesView.delegate = self
        tableFavoritesView.dataSource = self
        tableFavoritesView.prefetchDataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel = FavoritesViewModel(delegate: self)
        
        viewModel.fetchMovies()
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
        
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.movie(at: indexPath.row))
        }
        
        return cell
    }
    
}

extension FavoritesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        movieId = viewModel.movie(at: indexPath.row).id
        
        performSegue(withIdentifier: "goDetails", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension FavoritesController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchMovies()
        }
    }
}

extension FavoritesController: FavoritesViewModelDelegate {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
            
            tableFavoritesView.isHidden = false
            tableFavoritesView.reloadData()
            
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableFavoritesView.reloadRows(at: indexPathsToReload, with: .automatic)
        
    }
    
    func onFetchFailed(with reason: String) {
        activityIndicatorView.stopAnimating()
        
        let title = "Warning"
        
        let action = UIAlertAction(title: "OK", style: .default)
        
        displayAlert(with: title, message: reason, actions: [action])
        
    }
}

private extension FavoritesController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableFavoritesView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
