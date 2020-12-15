//
//  TableViewCell.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/2/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var circleProgressView: CircularProgressView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        #warning("clear values before")
        
        configure(with: .none)
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
            
            self.circleProgressView.progress = CGFloat(movie.rating) / 100
            indicatorView.stopAnimating()
            
        } else {
            indicatorView.startAnimating()
        }
    }
    
}
