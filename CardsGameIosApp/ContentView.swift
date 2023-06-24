import SwiftUI
import CoreData

struct ContentView: View {
    @State private var currentView: String? = nil
    @State private var playerName: String = ""
    @State private var selectedImage: String? = "red"
    @State private var showRedShadow: Bool = false
    @State private var isAnimating: Bool = false
    let defaults = UserDefaults.standard
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Card Game")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                Text("Choose Your Color")
                       .font(.system(size: 24, weight: .semibold))
                       .foregroundColor(.white)
                       .padding()
                       .shadow(color: .black, radius: 2, x: 0, y: 0)
                       .multilineTextAlignment(.center)
                
                HStack {
                    Image("yellow_watermelon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200)
                        .shadow(color: selectedImage == "green" ? Color.white : Color.clear, radius: 10)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .onTapGesture {
                            self.selectedImage = "green"
                            saveUserDefaults()
                        }
                    
                    Spacer()
                    
                    VStack {
                        
                          Text("User's Longitude")
                               .font(.system(size: 18, weight: .bold))
                               .foregroundColor(.white)
                               .shadow(color: .black, radius: 2, x: 0, y: 0)
                               .padding(.bottom, 8)
                           
                           Text("\(locationManager.userLongitude ?? 0)")
                               .font(.system(size: 24, weight: .semibold))
                               .foregroundColor(.white)
                               .shadow(color: .black, radius: 2, x: 0, y: 0)
                               .padding(.bottom, 16)
                    }
                    
                    Spacer()
                    
                    Image("pink_watermelon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200)
                        .shadow(color: selectedImage == "red" ? Color.white : Color.clear, radius: 10)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .onTapGesture {
                            self.selectedImage = "red"
                            saveUserDefaults()
                        }
                }
                .padding([.leading, .trailing])
                
                TextField("Enter Your Name", text: $playerName)
                    .font(.system(size: 20))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .shadow(color: showRedShadow ? .red : .clear, radius: 2)
                    .onChange(of: playerName) { newValue in
                        saveUserDefaults()
                    }
                
                NavigationLink(destination: GameView()) {
                    Text("Start Game")
                        .font(.system(size: 24, weight: .semibold))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                        )
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10, x: 2, y: 0)
                }
            }
            .padding()
            .onAppear {
                loadUserDefaults()
                startAnimating()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
    
    private func startAnimating() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                isAnimating = true
            }
        }
    }

    func saveUserDefaults() {
        defaults.set(playerName, forKey: "playerName")
        defaults.set(selectedImage, forKey: "selectedImage")
    }

    func loadUserDefaults() {
        playerName = defaults.string(forKey: "playerName") ?? ""
        selectedImage = defaults.string(forKey: "selectedImage") ?? "red"
    }
}

struct GlobalState {
    static var shouldNavigateBack: Bool = false
}



private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()



