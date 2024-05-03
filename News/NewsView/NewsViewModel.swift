//
//  NewsViewModel.swift
//  News
//
//  Created by Даниил Циркунов on 02.05.2024.
//

import SwiftUI

enum NewsCategory: String, CaseIterable {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}

class NewsViewModel: ObservableObject {
    @Published var news: [String: [NewsModel]] = [:]
    
    private var networkManager = NetworkManager()

    func loadNews(category: String) {
        networkManager.fetchNews(category: category) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self?.news[category] = articles
                    CoreDataManager.shared.saveNews(for: articles, category: category)
                case .failure(let error):
                    self?.news[category] = CoreDataManager.shared.allNewsModel(for: category)
                    print(error.localizedDescription)
                }
            }
        }
    }
}
