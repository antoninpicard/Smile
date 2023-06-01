import Foundation
import SwiftUI

struct DataProvider {
    static let phrases = [
        "Phrase 1",
        "Phrase 2",
        "Phrase 3",
        "Phrase 4"
    ]
    static let images = [
        "chien",
    ]
    
    static var lastPhrase: String?
    static var lastImage: String?

    static func getRandomPhrase() -> String {
        var newPhrase: String
        repeat {
            newPhrase = phrases.randomElement() ?? "Aucune phrase Disponible"
        } while newPhrase == lastPhrase
        lastPhrase = newPhrase
        return newPhrase
    }
        
    static func getRandomImage() -> String {
        var newImage: String
        repeat {
            newImage = images.randomElement() ?? "Aucune image Disponible"
        } while newImage == lastImage
        lastImage = newImage
        return newImage
    }
    
    static func getRandomContent() -> (String?, String?) {
        let contentType = Int.random(in: 0...1)
        
        if contentType == 0 {
            return (getRandomPhrase(), nil)
        } else {
            return (nil, getRandomImage())
        }
    }
}
