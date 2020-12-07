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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
    }
    
    static let identifier = "tableViewCell"
    
    func configure(with model: Movie) {
        self.titleLabel.text = model.title
        self.yearLabel.text = model.yearText
        
        
        let url = model.posterURL
        
        if let data = try? Data(contentsOf: url) {
            self.posterImageView.image = UIImage(data: data)
        }
        
        self.circleProgressView.progress = CGFloat(model.rating) / 100

    }
    
}
