//
//  NetworkManager.swift
//  News
//
//  Created by Даниил Циркунов on 02.05.2024.
//

import Foundation

class NetworkManager {
    private let apiKey1 = "b0e2dab5741e4fc5ab10d12d95612d2d"
    private let apiKey = "0ad457d63058477ab406e2c512eb8a5f"
    private let urlString = "https://newsapi.org/v2/top-headlines/"
    var tasks: [URLSessionDataTask] = []

    func fetchNews(category: String, completion: @escaping (Result<[NewsModel], Error>) -> Void) {
        let urlString = urlString + "?pageSize=20&country=us&category=\(category)&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }

            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(newsResponse.articles))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        tasks.append(task)
    }

    func cancelTask() {
        tasks.forEach {
            $0.cancel()
        }
    }
}
