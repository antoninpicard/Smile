import Foundation
import SwiftUI

struct DataProvider {
    static let phrases = [
        "Je t'aime comme le feu des dragons",
        "<3",
        "Crois moi tu es la meilleure",
        "Pense a un truc... sache que tu es capable de le faire"
    ]
    static let images = [
        "chien",
        "anto",
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
