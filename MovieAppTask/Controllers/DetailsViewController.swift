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
    @IBOutlet weak var circleProgessView: CircularProgressView!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    private var movie: Movie?
    private let movieService = MovieStore.shared
    var movieId: Int?
   
    private func showAlert(title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

              alert.addAction(UIAlertAction(title: "Try again",
                                            style: UIAlertAction.Style.default,
                                            handler: {(_: UIAlertAction!) in
              }))
              self.present(alert, animated: true, completion: nil)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieService.getMovie(id: movieId!) { (result) in
            switch result {
            case .success(let response):
                self.configure(with: response)
            case .failure(let error):
                self.showAlert(title: "Error", message: "\(error)")
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
        
        self.circleProgessView.progress = CGFloat(model.rating) / 100
                           
        self.circleProgessView.setProgressWithAnimation(duration: 2.0)
    }

}
