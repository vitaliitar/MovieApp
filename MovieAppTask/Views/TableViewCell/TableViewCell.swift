//
//  TableViewCell.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/2/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func favoriteTapped(at index: IndexPath)
}

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var circleProgressView: CircularProgressView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    private let coreDataService = CoreDataStore.shared
    private let movieService = MovieStore.shared
    
    private let coreDataManager = CoreDataManager.sharedManager
    
    var delegate: TableViewCellDelegate!
    var indexPath: IndexPath!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
    
    @IBAction func changeFavorite(_ sender: UIButton) {
        // check if contains
        
//       favoriteButton.setImage(UIImage(named: "filled_heart.png"), for: .normal)
        
//        let containsInFavorite = coreDataService.checkIfContains(id: sender.tag)
//
//        if containsInFavorite {
//            favoriteButton.setImage(UIImage(named: "heart.png"), for: .normal)
//            coreDataService.deleteById(id: sender.tag)
//            movieService.markFavourite(mediaId: sender.tag, favourite: false) { success in
//                print("\(success)")
//            }
//
//        } else {
//            favoriteButton.setImage(UIImage(named: "filled_heart.png"), for: .normal)
//            coreDataService.save(id: sender.tag)
//            movieService.markFavourite(mediaId: sender.tag, favourite: true) { success in
//                print("\(success)")
//            }
//        }
        print("index: \(indexPath.row)")
        self.delegate.favoriteTapped(at: indexPath)
        
//        self.save(title: "Serendipity", id: 5)
//        print(coreDataManager.fetchAllMovies())
        
    }
    
//    func save(title: String, id: Int) {
//        let _ = coreDataManager.insertMovie(id: id, title: title)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        indicatorView.hidesWhenStopped = true
        indicatorView.color = UIColor.green
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
    }
    
    static let identifier = "tableViewCell"
    
    func configure(with movie: Movie?) {
        if let movie = movie {
            self.titleLabel.text = movie.title
            self.yearLabel.text = movie.yearText
            
            let url = movie.posterURL
            
            if let data = try? Data(contentsOf: url) {
                self.posterImageView.image = UIImage(data: data)
            }
//            rewrite
            self.favoriteButton.tag = movie.id
            print("YEAHHHS")
            let containsInFavorite = coreDataService.checkIfContains(id: movie.id)
            
            if containsInFavorite {
                favoriteButton.setImage(UIImage(named: "filled_heart.png"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "heart.png"), for: .normal)
            }
            
            self.circleProgressView.progress = CGFloat(movie.rating) / 100
            indicatorView.stopAnimating()
            
        } else {
            indicatorView.startAnimating()
        }
    }
    
    func configureFromCoreData(with movie: MovieCoreData?) {
        print(movie?.title)
        self.titleLabel.text = movie?.title
        self.circleProgressView.progress = 0.8
    }
    
}
