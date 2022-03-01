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
    
   // @State var showLikeAnimation: Bool = false
    
    // This will keep track of the list of favourite
    @State var favourites: [DogImage] = []   // empty list to start
    
    // This will let us know whether the current exists as a favourite
    @State var currentImageAddedToFavourites: Bool = false
    
    // MARK: Computed properties
    var body: some View {
        
        ZStack {
            Color.yellow.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                ZStack {
                    // Shows the main image
                    RemoteImageView(fromURL: currentImage)
                        .padding(15)
                        .border(Color.gray, width: 4)
                        .padding()
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            //Like animation
                            LottieView(animationNamed: "84830-like-no-background")
                        //        .opacity(showLikeAnimation == true ? 1.0 : 0.0)
                                .frame(width: 150, height: 150, alignment: .center)
                                .padding()
                        }
                    }
                }
                
                //Button for regenerating an image
                Button(action: {
                    
                }, label: {
                    Text("New Image")
                        .font(.title)
                })
                    .padding()
                    .buttonStyle(GrowingButton())
                
                HStack {
                    Text("Favourites")
                        .bold()
                    
                    Spacer()
                }
                
                // Iterate over the list of favourites
                // As we iterate, each individual favourite is
                // accessible via "currentFavourite"
                List(favourites, id: \.self) { currentFavourite in
                    RemoteImageView(fromURL: currentImage)
                }
                .listStyle(.insetGrouped)
                
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
    //create a funtion to load new image
    func loadNewImage() async {
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
        // Define the type of data we want from the endpoint
        // Configure the request to the web site
        var request = URLRequest(url: url)
        // Ask for JSON data
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Try to fetch a new image
        // It might not work, so we use a do-catch block
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            //currentImage = try JSONDecoder().decode(DogImage.self, from: data)
            
            // Reset the flag that tracks whether the current joke
            // is a favourite
            currentImageAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }

    }
    
}

struct DogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DogView()
        }
    }
}
