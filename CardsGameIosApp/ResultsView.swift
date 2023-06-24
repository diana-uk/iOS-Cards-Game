import Foundation

import SwiftUI
import CoreData

struct ResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var winnerName: String = ""
    let defaults = UserDefaults.standard
    
    
    var body: some View {
        VStack {

            Text("\(winnerName) wins the war!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
                .padding()
            
            Spacer()
            
            Button(action: {
                GlobalState.shouldNavigateBack = true
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Go back to First View")
                    .foregroundColor(.black)
                    .fontWeight(.bold)


            }
        }
        .padding()
        .onAppear(perform: loadUserDefaults)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    func loadUserDefaults() {
        winnerName = defaults.string(forKey: "winnerName") ?? "PC"
    }
}
