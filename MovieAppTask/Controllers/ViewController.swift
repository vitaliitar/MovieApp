//
//  ViewController.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 11/30/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorField: UILabel!
    
    private var movies = [Movie]()
    private let movieService = MovieStore.shared
    private var movieId: Int?
    
    private func showAlert(title: String, message: String) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Try again",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
     }
    
    @IBAction func searchMovies(_ sender: UIButton) {
        let searchValue = textField.text!
        if (searchValue.isEmpty) {
            showAlert(title: "Error", message: "Enter correct movie name")
            return
        }
        
        movieService.searchMovie(query: searchValue) { (result) in
            switch result {
                case .success(let response):
                    self.movies = response.results
                    self.tableView.reloadSections([0], with: .none)
                    
                    if (self.movies.count == 0) {
                        self.errorField.text = "Nothing found by \(searchValue)"
                    }

                case .failure(let error):
                    print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        
        cell.configure(with: movies[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
        
        detailsViewController.movieId = movies[indexPath.item].id
        
        self.present(detailsViewController, animated:true, completion:nil)
    }
    
    

}

