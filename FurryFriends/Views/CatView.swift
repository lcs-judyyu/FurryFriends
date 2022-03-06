//
//  CatView.swift
//  FurryFriends
//
//  Created by Judy Yu on 2022-03-05.
//

import SwiftUI

struct CatView: View {
    
    // MARK: Stored properties
    
    // Address for main image
    // Starts as a transparent pixel – until an address for an animal's image is set
    @State var currentImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    
    @State var currentImageURL: CatImage = CatImage(file: "")
    
    // keep track of the list of favourite
    @State var favourites: [CatImage] = []   // empty list to start
    
    // Does the current exists as a favourite?
    @State var currentImageAddedToFavourites: Bool = false
    
    // MARK: Computed properties
    var body: some View {
        
        ZStack {
            Color.yellow.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                // Shows the main image
                RemoteImageView(fromURL: currentImage)
                    .padding(15)
                    .border(currentImageAddedToFavourites == true ? Color("pinkLike") : Color("pinkNotLike"), width: 4)
                
                ZStack {
                    
                    //Button for regenerating an image
                    Button(action: {
                        Task {
                            // Call the function to get a new image
                            await loadNewImage()
                        }
                        
                    }, label: {
                        Text("New Image")
                            .font(.title2)
                    })
                        .buttonStyle(GrowingButton())
                    
                    HStack {
                        Spacer()
                        
                        //like image
                        Image(systemName: "heart.circle")
                            .font(.system(size: 50))
                        
                            .clipShape(Capsule())
                            .padding(20)
                        //                      CONDITION                           true                 false
                            .foregroundColor(currentImageAddedToFavourites == true ? Color("pinkLike") : Color("pinkNotLike"))
                            .onTapGesture {
                                
                                // Only add to the list if it is not already there
                                if currentImageAddedToFavourites == false {
                                    if favourites.contains(currentImageURL) {

                                        currentImageAddedToFavourites = false
                                        
                                    } else {
                                        
                                        // Adds the current image to the list
                                        currentImage = URL(string: currentImageURL.file)!
                                        favourites.append(currentImageURL)
                                        
                                        // Record that we have marked this as a favourite
                                        currentImageAddedToFavourites = true
                                    }
                                    
                                } else {
                                    favourites.removeLast()
                                    currentImageAddedToFavourites = false
                                }
                            }
                        }
                    }
                
                HStack {
                    Text("Favourites")
                        .bold()
                        .padding(.leading)
                        .padding(.bottom, 10)
                    
                    Spacer()
                }
                
                // Iterate over the list of favourites
                // each individual favourite is accessible via "currentFavourite"
                List {
                    
                    ForEach(favourites, id: \.self) { currentFavourite in
                        
                        NavigationLink(destination: {
                            
                            ZStack {
                                Color.yellow.opacity(0.2)
                                    .edgesIgnoringSafeArea(.all)
                                
                                VStack(alignment: .center) {
                                    RemoteImageView(fromURL: URL(string: currentFavourite.file)!)
                                        .scaledToFit()
                                        .padding()
                                    
                                    Spacer()
                                }
                            }
                            
                        }, label: {
                            
                            RemoteImageView(fromURL: URL(string: currentFavourite.file)!)
                                .scaledToFill()
                                .frame(width: 320.0, height: 50.0, alignment: .center)
                                .clipped()
                            
                        })
                            .listRowBackground(Color.orange.opacity(0.4))
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
                
                
                // Push main image to top of screen
                Spacer()
                
            }
            // Runs once when the app is opened
            .task {
        
                // Example images for cat
                //let remoteCatImage = "https://purr.objects-us-east-1.dream.io/i/JJiYI.jpg"
                
                // Load an image from the endpoint
                await loadNewImage()
                
                print("I tried to load a new image")
                
            }
            .navigationTitle("Cats 🐱")
        }
        
    }
    
    // MARK: Functions
    //create a funtion to load new image
    func loadNewImage() async {
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://aws.random.cat/meow")!
        
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
            currentImageURL = try JSONDecoder().decode(CatImage.self, from: data)
            
            //put the file in the structure into a URL
            currentImage = URL(string: currentImageURL.file)!
            
            // Reset the Boolean value that tracks whether the current image is a favourite
            currentImageAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
        
    }
    
    //a function to delete items in the list
    func delete(at offsets: IndexSet) {
            favourites.remove(atOffsets: offsets)
        }
}

struct CatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CatView()
        }
    }
}