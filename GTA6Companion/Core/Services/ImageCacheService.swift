import Foundation
import UIKit

class ImageCacheService {
    static let shared = ImageCacheService()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    func image(for url: URL) async throws -> UIImage? {
        let key = url.absoluteString as NSString
        if let cachedImage = cache.object(forKey: key) {
            return cachedImage
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        if let image = UIImage(data: data) {
            cache.setObject(image, forKey: key)
            return image
        }
        return nil
    }
}
