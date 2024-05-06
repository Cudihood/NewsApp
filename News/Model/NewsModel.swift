//
//  NewsModel.swift
//  News
//
//  Created by Даниил Циркунов on 02.05.2024.
//

import Foundation

struct NewsResponse: Codable {
    let articles: [NewsModel]
}

struct NewsModel: Codable, Identifiable {
    let id: UUID = UUID()
    let title: String
    let description: String?
    let publishedAt: String
    let url: String?
    let urlToImage: String?
    let category: String?

    init(from object: News) {
        self.title = object.title ?? "No title"
        self.description = object.descriptionText ?? "No description"
        self.url = object.urlSting
        self.urlToImage = object.urlImageString
        self.category = object.category
        self.publishedAt = ""
    }
}
