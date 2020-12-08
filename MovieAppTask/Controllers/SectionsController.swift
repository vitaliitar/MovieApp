//
//  SectionsController.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/7/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import UIKit

class SectionsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var topRatedMovies = [Movie]()
    private var popularMovies = [Movie]()
    
    private let movieService = MovieStore.shared
    private var movieId: Int?

    
    @IBOutlet weak var tablePopularView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
             movieService.getPopularMovies(page: 1) { (result) in
                           switch result {
                           case .success(let response):
                                self.popularMovies = response.results
                                self.tablePopularView.reloadSections([0], with: .none)
                                print("\(self.popularMovies.count)")
        //                       self.configure(with: response)
                           case .failure(let error):
                            print(error)
        //                       self.showAlert(title: "Error", message: "\(error)")
                           }
                       }
        
        tablePopularView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        tablePopularView.delegate = self
        tablePopularView.dataSource = self
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 500
      }
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // should be count of server
        print(popularMovies.count)
          return popularMovies.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
          
          cell.configure(with: popularMovies[indexPath.row])
          
          return cell
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)

          movieId = popularMovies[indexPath.item].id
          
          performSegue(withIdentifier: "goDetailsView", sender: nil)
          
      }
    

}
