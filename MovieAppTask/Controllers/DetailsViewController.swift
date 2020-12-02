//
//  DetailsViewController.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/2/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var circleProgessView: UIView!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var movie: Movie?
    let movieService = MovieStore.shared
    var movieId: Int?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieService.getMovie(id: movieId!) { (result) in
            switch result {
            case .success(let response):
                self.configure(with: response)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
    }

    func configure(with model: Movie) {
        self.titleLabel.text = model.title
        self.overviewLabel.text = model.overview
        
        let url = model.posterURL
        
        if let data = try? Data(contentsOf: url) {
            self.posterImageView.image = UIImage(data: data)
        }
        
        self.voteCountLabel.text = String(model.voteCount)
        self.runtimeLabel.text = model.durationText
        self.releaseDateLabel.text = model.releaseDate
        
        var cp = CircularProgressView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        
        cp.progress = CGFloat(model.rating) / 100
            
        self.circleProgessView.addSubview(cp)
        
       
        cp.setProgressWithAnimation(duration: 2.0)
    }

}
