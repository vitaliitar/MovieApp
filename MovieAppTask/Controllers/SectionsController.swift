//
//  SectionsController.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/7/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit

class SectionsController: UIViewController, TableViewCellDelegate, AlertDisplayer {
    
    var coreDataManager = CoreDataManager.sharedManager
    
    func favoriteTapped(at index: IndexPath) {
        
        let movie = viewModel.movie(at: index.row)
        
        let containsInFavorite = coreDataManager.checkIfContains(id: movie.id)
        
        if containsInFavorite {
            coreDataManager.deleteById(movieId: movie.id)
            
        } else {
           coreDataManager.insertMovie(movieData: movie)
            
        }
        tablePopularView.reloadRows(at: [index], with: .automatic)
        
    }
    
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
        
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        
        NetworkManager.isReachable { _ in
            self.collectionTopRatedView.dataSource = self
            self.collectionTopRatedView.delegate = self
            
            self.collectionTopRatedView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
            
            self.indicatorView.color = UIColor.green
            self.indicatorView.startAnimating()
            
            self.tablePopularView.isHidden = true
            self.tablePopularView.separatorColor = UIColor.green
            
            self.tablePopularView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
            
            self.tablePopularView.delegate = self
            self.tablePopularView.dataSource = self
            self.tablePopularView.prefetchDataSource = self
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        
        NetworkManager.isReachable { _ in
            
            DispatchQueue.main.async {self.movieService.getTopRatedMovies { (result) in
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
            }
        }
        
        viewModel = MoviesViewModel(delegate: self)
        
        viewModel.fetchMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailsViewController {
            let vc = segue.destination as? DetailsViewController
            vc?.movieId = movieId
        }
    }
    
    private func showOfflinePage() {
        DispatchQueue.main.async {
            self.performSegue(
                withIdentifier: "NetworkLost",
                sender: self
            )
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
        
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        return CGSize(width: size.width, height: 130)
    }
}

extension SectionsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.totalCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
