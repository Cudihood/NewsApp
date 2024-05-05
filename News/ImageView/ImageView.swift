//
//  ImageView.swift
//  News
//
//  Created by Даниил Циркунов on 05.05.2024.
//

import SwiftUI

struct ImageView<Content: View>: View {
    @ObservedObject var loader: ImageLoader
    var placeholder: Content

    init(urlString: String, placeholder: () -> Content = { EmptyView() }) {
        loader = ImageLoader(urlString: urlString)
        self.placeholder = placeholder()
    }

    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                placeholder

                ProgressView()
            }
        }
    }
}

