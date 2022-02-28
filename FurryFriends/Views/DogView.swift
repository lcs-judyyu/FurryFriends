//
//  ContentView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

//button style
struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(configuration.isPressed ? Color.orange.opacity(0.5) : Color.orange.opacity(0.2))
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.orange, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 1.06 : 1)
            .animation(.easeOut(duration: 0.3), value: configuration.isPressed)
    }
}

struct DogView: View {
    
    // MARK: Stored properties
    
    // Address for main image
    // Starts as a transparent pixel – until an address for an animal's image is set
    @State var currentImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    
    // MARK: Computed properties
    var body: some View {
        
        ZStack {
            Color.yellow.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // Shows the main image
                RemoteImageView(fromURL: currentImage)
                    .padding(15)
                    .border(Color.gray, width: 4)
                    .padding()
                
                //Button for regenerating an image
                
                // Push main image to top of screen
                Spacer()

            }
            // Runs once when the app is opened
            .task {
                
                // Example images for each type of pet
                //let remoteCatImage = "https://purr.objects-us-east-1.dream.io/i/JJiYI.jpg"
                let remoteDogImage = "https://images.dog.ceo/breeds/labrador/lab_young.JPG"
                
                // Replaces the transparent pixel image with an actual image of an animal
                // Adjust according to your preference ☺️
                currentImage = URL(string: remoteDogImage)!
                            
            }
        .navigationTitle("Furry Friends")
        }
        
    }
    
    // MARK: Functions
    
}

struct DogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DogView()
        }
    }
}
