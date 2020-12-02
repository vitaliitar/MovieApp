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
    
    var movies = [Movie]()
    let movieService = MovieStore.shared
    var movieId: Int?
    
    @IBAction func searchMovies(_ sender: UIButton) {
        let searchValue = textField.text!
//        check if empty
        
        movieService.searchMovie(query: searchValue) { (result) in
            switch result {
                case .success(let response):
                    self.movies = response.results
                    self.tableView.reloadSections([0], with: .none)
                    
                    // check if no movies found
                case .failure(let error):
                    print(error)
                    // reload page nothing found

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
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
        
        detailsViewController.movieId = movies[indexPath.item].id
        
        detailsViewController.modalPresentationStyle = .fullScreen
        self.present(detailsViewController, animated:true, completion:nil)
    }
    
    

}

