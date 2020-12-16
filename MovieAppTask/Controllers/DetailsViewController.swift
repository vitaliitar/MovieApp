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
    private let coreDataService = CoreDataStore.shared
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
        print(sender.tag)
        let containsInFavorite = coreDataService.checkIfContains(id: sender.tag)
        
        if containsInFavorite {
            favoriteButton.setImage(UIImage(named: "heart.png"), for: .normal)
            coreDataService.deleteById(id: sender.tag)
            movieService.markFavourite(mediaId: sender.tag, favourite: false) { success in
                if !success {
                    let title = "Error"
                    
                    let action = UIAlertAction(title: "OK", style: .default)
                    
                    self.displayAlert(with: title, message: "Network error", actions: [action])
                }
            }
            
        } else {
            favoriteButton.setImage(UIImage(named: "filled_heart.png"), for: .normal)
            coreDataService.save(id: sender.tag)
            movieService.markFavourite(mediaId: sender.tag, favourite: true) { success in
                if !success {
                    let title = "Error"
                    
                    let action = UIAlertAction(title: "OK", style: .default)
                    
                    self.displayAlert(with: title, message: "Network error", actions: [action])
                }
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        
        self.favoriteButton.tag = model.id
        
        let containsInFavorite = coreDataService.checkIfContains(id: model.id)
        
        if containsInFavorite {
            favoriteButton.setImage(UIImage(named: "filled_heart.png"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "heart.png"), for: .normal)
        }
        
        self.circleProgessView.progress = CGFloat(model.rating) / 100
        
        self.circleProgessView.setProgressWithAnimation(duration: 2.0)
    }
    
}
