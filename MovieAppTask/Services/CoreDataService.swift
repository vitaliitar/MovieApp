//
//  MovieService.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/2/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataService {
    func save(id: Int)
    func retrieve()
    func deleteFromCoreData()
    func deleteById(id: Int)
    func checkIfContains(id: Int) -> Bool
}
