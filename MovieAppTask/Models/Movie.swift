//
//  Movie.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 11/30/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
    let page: Int
    let totalResults: Int
}

struct Movie: Decodable, Identifiable, Hashable {
    
    var id: Int
    var title: String
    var posterPath: String?
    var overview: String
    var voteAverage: Double
    var voteCount: Int
    var runtime: Int?
    var releaseDate: String?
    
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var rating: Int {
        return Int(voteAverage * 10)
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return Movie.yearFormatter.string(from: date)
    }
    
    var durationText: String {
        guard let runtime = self.runtime, runtime > 0 else {
            return "n/a"
        }
        return Movie.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }    
}
