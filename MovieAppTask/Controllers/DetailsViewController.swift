//
//  DetailsViewController.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/2/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, AlertDisplayer {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var circleProgessView: CircularProgressView!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    private var movie: Movie?
    private let movieService = MovieStore.shared
    private let coreDataManager = CoreDataManager.sharedManager
    var movieId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieService.getMovie(id: movieId!) { (result) in
            switch result {
            case .success(let response):
                self.configure(with: response)
            case .failure(let error):
                let title = "Error"
                
                let action = UIAlertAction(title: "OK", style: .default)
                
                self.displayAlert(with: title, message: error.localizedDescription, actions: [action])
            }
        }
        
    }
    
    @IBAction func changeFavorite(_ sender: UIButton) {
        let containsInFavorite = coreDataManager.checkIfContains(id: movieId!)
        
        if containsInFavorite {
            favoriteButton.setImage(UIImage(named: "heart.png"), for: .normal)
            
            coreDataManager.deleteById(movieId: movieId!)
            
        } else {
            favoriteButton.setImage(UIImage(named: "filled_heart.png"), for: .normal)
            coreDataManager.insertMovie(movieData: movie!)
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func configure(with model: Movie) {
        movie = model
        
        self.titleLabel.text = model.title
        self.overviewLabel.text = model.overview
        
        let url = model.posterURL
        
        if let data = try? Data(contentsOf: url) {
            self.posterImageView.image = UIImage(data: data)
        }
        
        self.voteCountLabel.text = String(model.voteCount)
        self.runtimeLabel.text = model.durationText
        self.releaseDateLabel.text = model.releaseDate
        
        let containsInFavorite = coreDataManager.checkIfContains(id: model.id)
        
        if containsInFavorite {
            favoriteButton.setImage(UIImage(named: "filled_heart.png"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "heart.png"), for: .normal)
        }
        
        self.circleProgessView.progress = CGFloat(model.rating) / 100
        
        self.circleProgessView.setProgressWithAnimation(duration: 2.0)
    }
    
}
