//
//  MovieStore.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/2/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

import Foundation

class MovieStore: MovieService {
    
    static let shared = MovieStore()
    private init() {}
    
    private let apiKey = "5113bc5f30e7bd2ae86759d199533bc6"
    private let sessionId = "6bfd39fda80dfc4443a1790a5f10b554b2b19eee"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let accountId = "9872680"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    func getMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> Void) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "append_to_response": "videos,credits"
        ], completion: completion)
    }
    
    func getFavoriteMovies(page: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> Void) {
        guard let url = URL(string: "\(baseAPIURL)/account/\(accountId)/favorite/movies") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadURLAndDecode(url: url, params: [
            "session_id": "\(sessionId)",
            "page": "\(page)"
        ], completion: completion)
        
    }
    
    func markFavourite(mediaId: Int, favourite: Bool, completion: @escaping (Bool) -> Void) {
        let json: [String: Any] = ["media_type": "movie", "media_id": mediaId, "favorite": favourite]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        guard let url = URL(string: "\(baseAPIURL)/account/9872680/favorite?api_key=\(apiKey)&session_id=\(sessionId)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                if responseJSON["success"] as? Int == 1 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }.resume()
        
    }
    
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> Void) {
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": query
        ], completion: completion)
    }
    
    func getTopRatedMovies(completion: @escaping (Result<MovieResponse, MovieError>) -> Void) {
        guard let url = URL(string: "\(baseAPIURL)/movie/top_rated") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    func getPopularMovies(page: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> Void) {
        guard let url = URL(string: "\(baseAPIURL)/movie/popular") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "page": "\(page)"
            ],
                              completion: completion)
    }
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> Void) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping (Result<D, MovieError>) -> Void) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}
