//
//  CoreDataManager.swift
//  News
//
//  Created by Даниил Циркунов on 03.05.2024.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let viewContext = PersistenceController.shared.container.viewContext

    private var allNews: [News] {
        var news: [News] = []
        do {
            news = try viewContext.fetch(News.fetch())
        } catch {
            print("Error fething. \(error)")
        }
        return news
    }

    private init() {}

    func allNewsModel(for category: String) -> [NewsModel] {
        allNews.map { NewsModel(from: $0) }.filter { $0.category == category }
    }

    func saveNews(for models: [NewsModel], category: String) {
        deleteAll(for: category)
        models.forEach {
            let news = News(context: viewContext)
            news.id = $0.id
            news.urlImageString = $0.urlToImage
            news.title = $0.title
            news.urlSting = $0.url
            news.category = category
        }
        viewContext.saveContext()
    }

    func deleteAll(for category: String) {
        allNews.forEach {
            if $0.category == category {
                viewContext.delete($0)
            }
        }
        viewContext.saveContext()
    }
}
