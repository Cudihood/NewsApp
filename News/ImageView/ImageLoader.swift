//
//  ImageLoader.swift
//  News
//
//  Created by Даниил Циркунов on 05.05.2024.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private static let imageCache = NSCache<NSString, UIImage>()

    private var urlString: String
    private var cancellables = Set<AnyCancellable>()

    init(urlString: String) {
        self.urlString = urlString
        loadImage()
    }

    func loadImage() {
        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlString) {
            if let cachedImage = ImageLoader.imageCache.object(forKey: NSString(string: urlString)) {
                self.image = cachedImage
                return
            }

            URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] downloadedImage in
                    guard let image = downloadedImage else {
                        self?.image = UIImage()
                        return
                    }
                    self?.image = image
                    self?.cache(image: image, forKey: urlString)
                }
                .store(in: &cancellables)
        }
    }

    func cache(image: UIImage, forKey key: String) {
        ImageLoader.imageCache.setObject(image, forKey: NSString(string: key))
    }
}

