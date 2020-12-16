//
//  CollectionViewCell.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/8/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageContainerView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var reuseIdentifier = "collectionViewCellReuseIdentifier"
    static let nibName = "collectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    func configure(with movie: Movie) {
        
        self.titleLabel.text = movie.title
        
        let url = movie.posterURL
        
        if let data = try? Data(contentsOf: url) {
            self.imageContainerView.image = UIImage(data: data)
        }
    }
    
}
