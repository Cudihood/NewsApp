//
//  NetworkManager.swift
//  News
//
//  Created by Даниил Циркунов on 02.05.2024.
//

import Foundation

typealias NetworkRequestResult = Result<[NewsModel], NetworkError>

class NetworkManager {
    private let apiKey1 = "b0e2dab5741e4fc5ab10d12d95612d2d"
    private let apiKey = "0ad457d63058477ab406e2c512eb8a5f"
    private let urlString = "https://newsapi.org/v2/top-headlines/"
    var tasks: [URLSessionDataTask] = []

    func fetchNews(category: String, completion: @escaping (NetworkRequestResult) -> Void) {
        let urlString = urlString + "?pageSize=20&country=us&category=\(category)&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else { return completion(.failure(.invalidURL)) }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                let nsError = error as NSError
                if nsError.code == -1009 {
                    completion(.failure(.notConnectedToInternet))
                } else {
                    completion(.failure(.invalidError(string: error.localizedDescription)))
                }
                return
            }

            guard let data = data, let response = response else {
                completion(.failure(.notDataAndResponse))
                return
            }

            completion(self.getResponse(urlResponse: response, data: data))
        }
        task.resume()
        tasks.append(task)
    }

    func cancelTask() {
        tasks.forEach {
            $0.cancel()
        }
    }

    func getResponse(urlResponse: URLResponse, data: Data) -> NetworkRequestResult {
        guard let response = urlResponse as? HTTPURLResponse else {
            return .failure(.invalidServerResponse(code: nil))
        }
        switch response.statusCode {
        case 200:
            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                return .success(newsResponse.articles)
            } catch {
                return .failure(.invalidData)
            }
        case 503:
            return .failure(.serverUnavailable)
        default:
            return .failure(.invalidServerResponse(code: response.statusCode))
        }
    }
}
