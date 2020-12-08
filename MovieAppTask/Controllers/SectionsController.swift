//
//  SectionsController.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/7/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit

class SectionsController: UIViewController {

    
    
    //    private var topRatedMovies = [Movie]()
//    private var popularMovies = [Movie]()
    
    private let movieService = MovieStore.shared
    private var movieId: Int?

    
    @IBOutlet weak var tablePopularView: UITableView!
    
    private var viewModel: MoviesViewModel!
    
    private var shouldShowLoadingCell = false
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        indicatorView.color = UIColor.green
        indicatorView.startAnimating()
        
        tablePopularView.isHidden = true
        tablePopularView.separatorColor = UIColor.green
        
        tablePopularView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)

        tablePopularView.dataSource = self
        tablePopularView.prefetchDataSource = self
        
        viewModel = MoviesViewModel(delegate: self)
        
        viewModel.fetchMovies()
        
        
    }

}

extension SectionsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.totalCount)
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
           
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        }
        else {
            cell.configure(with: viewModel.movie(at: indexPath.row))
        }
           
           return cell
       }
    

}

extension SectionsController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchMovies()
        }
    }
}

extension SectionsController: MoviesViewModelDelegate {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            indicatorView.stopAnimating()
            
            tablePopularView.isHidden = false
            tablePopularView.reloadData()

            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tablePopularView.reloadRows(at: indexPathsToReload, with: .automatic)

    }
    
    func onFetchFailed(with reason: String) {
        // indicator
        indicatorView.stopAnimating()
        
        let title = "Warning"
        
        let action = UIAlertAction(title: "OK", style: .default)
        
        // todo display alert
        
    }
}


private extension SectionsController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tablePopularView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
