import Foundation

struct DataProvider {
    
    static func getRandomPhrase(completion: @escaping (String) -> Void) {
        let url = URL(string: "https://smile-api.vercel.app/api/randomcontroller/randomphrase")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Erreur lors de la récupération de la phrase: \(error)")
                completion("Erreur lors de la récupération de la phrase")
            } else if let data = data {
                let phrase = String(data: data, encoding: .utf8)
                completion(phrase ?? "Erreur lors de la décodage de la phrase")
            }
        }
        task.resume()
    }
    
    static func getRandomImage(completion: @escaping (URL?) -> Void) {
        let url = URL(string: "https://smile-api.vercel.app/api/randomcontroller/randomimage")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Erreur lors de la récupération du nom de l'image: \(error)")
                completion(nil)
            } else if let data = data,
                      let jsonString = String(data: data, encoding: .utf8),
                      let imageJson = try? JSONDecoder().decode([String: String].self, from: jsonString.data(using: .utf8)!),
                      let imageName = imageJson["imageName"] {
                let imageURL = URL(string: "https://smile-api.vercel.app/Images/" + imageName)
                completion(imageURL)
            }
        }
        task.resume()
    }

}
