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
    
    @NSManaged public var adult: Bool
    @NSManaged public var backdrop_path: String?
    @NSManaged public var genre_ids: [Int]
    @NSManaged public var id: Int
    @NSManaged public var original_language: String?
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String
    @NSManaged public var popularite: Double
    @NSManaged public var poster_path: String
    @NSManaged public var title: String
    @NSManaged public var video: Bool
    @NSManaged public var vote_average: Double
    @NSManaged public var vote_count: Int
    
    
}
