//
//  ViewController.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 11/30/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate, AlertDisplayer {
    var coreDataManager = CoreDataManager.sharedManager
    private let coreDataService = CoreDataStore.shared
    
    func favoriteTapped(at index: IndexPath) {
        let movie = movies[index.row]
        
        let containsInFavorite = coreDataService.checkIfContains(id: movie.id)
        
        if containsInFavorite {
            coreDataService.deleteById(id: movie.id)
            coreDataManager.deleteById(movieId: movie.id)
            
        } else {
            let _ = coreDataManager.insertMovie(movieData: movie)
            
            coreDataService.save(id: movie.id)
            
        }
        tableView.reloadRows(at: [index], with: .automatic)
        
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorField: UILabel!
    
    private var movies = [Movie]()
    private let movieService = MovieStore.shared
    private var movieId: Int?
    
    @IBAction func findMovies(_ sender: UITextField) {
        let searchValue = textField.text!
        if searchValue.isEmpty {
            return
        }
        
        movieService.searchMovie(query: searchValue) { (result) in
            switch result {
            case .success(let response):
                self.movies = response.results
                self.tableView.reloadSections([0], with: .none)
                
                if self.movies.count == 0 {
                    self.errorField.text = "Nothing found by \(searchValue)"
                } else {
                    self.errorField.text = ""
                }
                
            case .failure(let error):
                let title = "Error"
                
                let action = UIAlertAction(title: "Incorrect data", style: .default)
                
                self.displayAlert(with: title, message: error.localizedDescription, actions: [action])
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
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.configure(with: movies[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        movieId = movies[indexPath.item].id
        
        performSegue(withIdentifier: "goDetailsView", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailsViewController {
            let vc = segue.destination as? DetailsViewController
            vc?.movieId = movieId
        }
    }
}
