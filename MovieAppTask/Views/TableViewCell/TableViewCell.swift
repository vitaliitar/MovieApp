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
    
    private let movieService = MovieStore.shared
    
    private let coreDataManager = CoreDataManager.sharedManager
    
    var delegate: TableViewCellDelegate!
    var indexPath: IndexPath!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
    
    @IBAction func changeFavorite(_ sender: UIButton) {
        
        self.delegate.favoriteTapped(at: indexPath)
        
    }
        
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
            
            let containsInFavorite = coreDataManager.checkIfContains(id: movie.id)
            
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
        
        let yearFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            return formatter
        }()
        
        var yearText: String {
            guard let releaseDate = movie?.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
                return "n/a"
            }
            return yearFormatter.string(from: date)
        }
        
        if let movie = movie {
            
            self.titleLabel.text = movie.title
            
            self.yearLabel.text = yearText
            
            self.circleProgressView.progress = CGFloat(Int(movie.voteAverage * 10)) / 100.0
            
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")!
            
            if let data = try? Data(contentsOf: url) {
                self.posterImageView.image = UIImage(data: data)
            }
            
            favoriteButton.setImage(UIImage(named: "filled_heart.png"), for: .normal)
            
            indicatorView.stopAnimating()
        } else {
            indicatorView.startAnimating()
        }
        
    }
    
}
