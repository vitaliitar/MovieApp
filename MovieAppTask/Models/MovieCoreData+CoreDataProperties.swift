//
//  MovieCoreData+CoreDataProperties.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/21/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import Foundation
import CoreData

extension MovieCoreData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCoreData> {
        return NSFetchRequest<MovieCoreData>(entityName: "MovieCoreData")
    }
    
    @NSManaged public var id: Int
    @NSManaged public var overview: String
    @NSManaged public var popularite: Double
    @NSManaged public var posterPath: String
    @NSManaged public var title: String
    @NSManaged public var video: Bool
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int
    @NSManaged public var releaseDate: String
    
}
