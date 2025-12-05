import UIKit

class ImageCache {

    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    func load(urlString: String?, completion: @escaping (UIImage?) -> Void) {

        guard let str = urlString, let url = URL(string: str) else {
            completion(nil)
            return
        }

        if let cached = cache.object(forKey: str as NSString) {
            completion(cached)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: str as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
