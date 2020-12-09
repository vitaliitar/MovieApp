//
//  MovieService.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/2/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import Foundation

protocol MovieService {
    func getTopRatedMovies(completion: @escaping (Result<MovieResponse, MovieError>) -> Void)
    func getPopularMovies(page: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> Void)
    func getMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> Void)
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> Void)
}

enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String: Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}
