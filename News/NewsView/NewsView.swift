//
//  ContentView.swift
//  News
//
//  Created by Даниил Циркунов on 02.05.2024.
//

import SwiftUI
import CoreData
import struct Kingfisher.KFImage

struct NewsView: View {
    @StateObject var viewModel = NewsViewModel()

    var body: some View {
        VStack {
            titleView

            searchView

            if viewModel.news.isEmpty {
                Spacer()

                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button {
                        viewModel.loadNews()
                    } label: {
                        Text("To retry")
                    }
                }

                Spacer()
            } else {
                newsCollectionView
            }
        }
        .alert(isPresented: $viewModel.isShowAlert) {
            alertView
        }
    }
}

#Preview {
    NewsView()
}

private extension NewsView {
    var titleView: some View {
        Text("News")
            .font(.title2)
            .bold()
    }

    var searchView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 6)

            TextField(text: $viewModel.searchText) {
                Text("Search news")
            }
        }
        .frame(height: 40)
        .background(.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    var newsCollectionView: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                let categories = viewModel.filterNews.keys.sorted(by: { $0 < $1 })
                ForEach(categories, id:\.self) { category in
                    VStack(alignment: .leading) {
                        Text(category.capitalized)
                            .bold()
                            .font(.title3)
                            .padding(.vertical, 16)

                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                let newsByCategory = viewModel.filterNews[category] ?? []
                                ForEach(newsByCategory) { article in
                                    Button {
                                        if let urlString = article.url, let url = URL(string: urlString) {
                                            UIApplication.shared.open(url)
                                        }
                                    } label: {
                                        newsCell(for: article)
                                    }
                                }

                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
        }
        .padding()
    }

    var alertView: Alert {
        Alert(
            title: Text("Внимание"),
            message: Text(viewModel.alertText)
        )
    }

    func newsCell(for model: NewsModel) -> some View {
        ZStack {
            imageView(for: model.urlToImage ?? "")
                .frame(width: 200, height: 300)

            VStack {
                Spacer()

                Text(model.title)
                    .multilineTextAlignment(.trailing)
                    .padding()
                    .padding(.leading, 30)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [.white.opacity(0.2), .black.opacity(0.8)]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .frame(width: 200, height: 300)
        .cornerRadius(20)
    }

    func imageView(for urlString: String) -> some View {
        KFImage(URL(string: urlString))
            .placeholder {
                Color.gray
                    .opacity(0.2)
            }
            .resizable()
            .scaledToFill()
    }
}
