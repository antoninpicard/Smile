import SwiftUI
import Combine

// L'extension Color pour les couleurs hexadécimales
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ContentView: View {
    @State private var currentContent: String = ""
    @State private var currentImageUrl: URL? = nil
    @State private var contentOpacity: Double = 1.0
    @State private var imageOpacity: Double = 1.0
    @State private var timerCancellable: AnyCancellable?
    @State private var displayImage: Bool = false
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if displayImage, let imageUrl = currentImageUrl {
                    AsyncImage(url: imageUrl, scale: 1.0) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .opacity(imageOpacity)
                    } placeholder: {
                        ProgressView()
                    }
                    .edgesIgnoringSafeArea(.all)
                } else {
                    Text(currentContent)
                        .font(.custom("Boba Milky", size: 18))
                        .multilineTextAlignment(.center)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .opacity(contentOpacity)
                }
            }
            .background(Color(hex: "CC7178"))

        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                timerCancellable = Timer.publish(every: 10, on: .main, in: .common).autoconnect().sink { _ in
                    displayImage.toggle()
                    if displayImage {
                        imageOpacity = 0.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            DataProvider.getRandomImage { imageUrl in
                                DispatchQueue.main.async {
                                    currentImageUrl = imageUrl
                                    imageOpacity = 1.0
                                }
                            }
                        }
                    } else {
                        contentOpacity = 0.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            DataProvider.getRandomPhrase { phrase in
                                DispatchQueue.main.async {
                                    currentContent = phrase
                                    contentOpacity = 1.0
                                }
                            }
                        }
                    }
                }
            case .background, .inactive:
                timerCancellable?.cancel()
                timerCancellable = nil
            @unknown default:
                break
            }
        }
        .animation(.easeInOut(duration: 0.5), value: contentOpacity)
        .animation(.easeInOut(duration: 0.5), value: imageOpacity)
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
