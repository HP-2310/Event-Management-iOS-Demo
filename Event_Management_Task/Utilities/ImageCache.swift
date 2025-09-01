//
//  ImageCache.swift
//  Event_Management_Task
//
//  Created by HP's Mac on 30/08/25.
//

import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    
    private static let cache = NSCache<NSURL, UIImage>()
    private var url: URL?
    
    func load(from url: URL?) {
        self.url = url
        
        guard let url = url else { return }
        
        //Return cached image if available
        if let cached = Self.cache.object(forKey: url as NSURL) {
            self.image = cached
            return
        }
        
        // Otherwise download
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let downloaded = UIImage(data: data) {
                    // Cache it
                    Self.cache.setObject(downloaded, forKey: url as NSURL)
                    // Update on main thread
                    await MainActor.run {
                        if self.url == url {
                            self.image = downloaded
                        }
                    }
                }
            } catch {
                print("❌ Image download failed: \(error.localizedDescription)")
            }
        }
    }
}

struct CachedAsyncImage: View {
    @StateObject private var loader = ImageLoader()
    let url: URL?
    let placeholder: Image
    
    init(url: URL?, placeholder: Image = Image(systemName: "photo")) {
        self.url = url
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.4))
            }
        }
        .onAppear {
            loader.load(from: url)
        }
    }
}
