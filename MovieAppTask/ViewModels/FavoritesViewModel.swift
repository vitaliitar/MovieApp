//
//  FavoritesViewModel.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/15/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import Foundation

protocol FavoritesViewModelDelegate: class {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
  func onFetchFailed(with reason: String)
}

final class FavoritesViewModel {
  private weak var delegate: FavoritesViewModelDelegate?

  private var favoriteMovies: [Movie] = []
  private var currentPage = 1
  private var total = 0
  private var isFetchInProgress = false

  private let movieService = MovieStore.shared

  init(delegate: FavoritesViewModelDelegate) {
    self.delegate = delegate
  }

  var totalCount: Int {
    return total
  }

  var currentCount: Int {
    return favoriteMovies.count
  }

  func movie(at index: Int) -> Movie {
    #warning("Strange behaviour without internet and crashes")

    return favoriteMovies[index]
  }

  func fetchMovies() {
    guard !isFetchInProgress else {
      return
    }

    isFetchInProgress = true

    movieService.getFavoriteMovies(page: currentPage) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {

                    self.currentPage += 1
                    self.isFetchInProgress = false

                    #warning("Why 10000?")
                    self.total = 2
                    self.favoriteMovies.append(contentsOf: response.results)

                    if response.page > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.results)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }

            case .failure(let error):
                print("\(error)")
                self.isFetchInProgress = false
            }
        }
  }

  private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
    let startIndex = favoriteMovies.count - newMovies.count
    let endIndex = startIndex + newMovies.count
    return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
  }

}
