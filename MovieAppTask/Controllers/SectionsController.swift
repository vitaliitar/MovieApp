//
//  SectionsController.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/7/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit

class SectionsController: UIViewController, AlertDisplayer {
    
    private var topRatedMovies = [Movie]()
    
    private let movieService = MovieStore.shared
    private var movieId: Int?
    
    @IBOutlet weak var tablePopularView: UITableView!
    
    @IBOutlet weak var collectionTopRatedView: UICollectionView!
    
    private var viewModel: MoviesViewModel!
    
    private var shouldShowLoadingCell = false
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieService.getTopRatedMovies { (result) in
            switch result {
            case .success(let response):
                self.topRatedMovies = response.results
                self.collectionTopRatedView.reloadData()
                
            case .failure(let error):
                
                let title = "Error"
                
                let action = UIAlertAction(title: "OK", style: .default)
                
                self.displayAlert(with: title, message: error.localizedDescription, actions: [action])
            }
        }
        
        collectionTopRatedView.dataSource = self
        collectionTopRatedView.delegate = self
        
        collectionTopRatedView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        
        indicatorView.color = UIColor.green
        indicatorView.startAnimating()
        
        tablePopularView.isHidden = true
        tablePopularView.separatorColor = UIColor.green
        
        tablePopularView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        
        tablePopularView.delegate = self
        tablePopularView.dataSource = self
        tablePopularView.prefetchDataSource = self
        
        viewModel = MoviesViewModel(delegate: self)
        
        viewModel.fetchMovies()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 150
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailsViewController {
            let vc = segue.destination as? DetailsViewController
            vc?.movieId = movieId
        }
    }
}

extension SectionsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieId = topRatedMovies[indexPath.row].id

        performSegue(withIdentifier: "goToDetailsView", sender: nil)
    }
}

extension SectionsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topRatedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell {
            
            let movie = topRatedMovies[indexPath.row]
            
            cell.configure(with: movie)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

extension SectionsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: CollectionViewCell = Bundle.main.loadNibNamed(CollectionViewCell.nibName,
                                                                      owner: self,
                                                                      options: nil)?.first as? CollectionViewCell else {
            return CGSize.zero
        }

        cell.configure(with: topRatedMovies[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        #warning("Some images looks bad, the reason is with wrong logic for calculation")

        return CGSize(width: 100, height: 130)
    }
}

extension SectionsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #warning("This value should not be hardcoded")

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

extension SectionsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        movieId = viewModel.movie(at: indexPath.row).id
        
        performSegue(withIdentifier: "goToDetailsView", sender: nil)
        
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
            indicatorView.isHidden = true
            
            tablePopularView.isHidden = false
            tablePopularView.reloadData()
            
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tablePopularView.reloadRows(at: indexPathsToReload, with: .automatic)
        
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        
        let title = "Warning"
        
        let action = UIAlertAction(title: "OK", style: .default)
        
        displayAlert(with: title, message: reason, actions: [action])
        
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
