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

final class NewsViewModel: ObservableObject {
    @Published var news: [String: [NewsModel]] = [:]
    @Published var searchText: String = ""
    @Published var isShowAlert = false
    @Published var isLoading = false
    
    var alertText = ""

    var filterNews: [String: [NewsModel]] {
        if searchText.isEmpty { return news }
        let filtered = news.mapValues { newsList in
            newsList.filter {
                let description = $0.description ?? ""
                return $0.title.contains(searchText) || description.contains(searchText)
            }
        }
        return filtered.filter { !$0.value.isEmpty }
    }

    private let networkManager = NetworkManager()
    private let group = DispatchGroup()

    init() {
        loadNews()
    }

    func loadNews() {
        isLoading = true
        NewsCategory.allCases.forEach {
            loadNews(for: $0.rawValue)
        }

        group.notify(queue: .main) {
            self.isLoading = false
            NewsCategory.allCases.forEach {
                let category = $0.rawValue
                let sortNewsByData = CoreDataManager.shared.allNewsModel(for: category).sorted(by: { $0.publishedAt > $1.publishedAt })
                self.news[category] = sortNewsByData.isEmpty ? nil : sortNewsByData
            }
        }
    }

    private func loadNews(for category: String) {
        group.enter()
        networkManager.fetchNews(category: category) { [weak self] result in
            DispatchQueue.main.async {
                self?.group.leave()
                switch result {
                case .success(let articles):
                    CoreDataManager.shared.saveNews(for: articles, category: category)
                case .failure(let error):
                    let errorText = "Error feth: \(error)"
                    self?.alertText = errorText
                    self?.isShowAlert = true
                }
            }
        }
    }
}
