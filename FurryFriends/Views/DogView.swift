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
    //Detect when app moves between foreground, background, and inactive atates
    @Environment(\.scenePhase) var scenePhase
    
    // Address for main image
    // Starts as a transparent pixel – until an address for an animal's image is set
    @State var currentImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    
    @State var currentImageURL: DogImage = DogImage(message: "")
    
    // keep track of the list of favourite
    @State var favourites: [DogImage] = []   // empty list to start
    
    // Does the current exists as a favourite?
    @State var currentImageAddedToFavourites: Bool = false
    
    // MARK: Computed properties
    var body: some View {
        
        ZStack {
            Color.yellow.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                MainImageView(currentImage: currentImage, currentImageAddedToFavourites: $currentImageAddedToFavourites)
                
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
                                        currentImage = URL(string: currentImageURL.message)!
                                        favourites.append(currentImageURL)
                                        
                                        // Record that we have marked this as a favourite
                                        currentImageAddedToFavourites = true
                                        
                                        persistFavourites()
                                    }
                                    
                                } else {
                                    favourites.removeLast()
                                    currentImageAddedToFavourites = false
                                    persistFavourites()
                                }
                            }
                    }
                }
                
                FavouritesTitleView()
                
                // Iterate over the list of favourites
                // each individual favourite is accessible via "currentFavourite"
                List {
                    
                    ForEach(favourites, id: \.self) { currentFavourite in
                        
                        NavigationLink(destination: {
                            
                            ZStack {
                                Color.yellow.opacity(0.2)
                                    .edgesIgnoringSafeArea(.all)
                                
                                VStack(alignment: .center) {
                                    RemoteImageView(fromURL: URL(string: currentFavourite.message)!)
                                        .scaledToFit()
                                        .padding()
                                    
                                    Spacer()
                                }
                            }
                            
                        }, label: {
                            
                            RemoteImageView(fromURL: URL(string: currentFavourite.message)!)
                                .scaledToFill()
                                .frame(width: 320.0, height: 50.0, alignment: .center)
                                .clipped()
                            
                        })
                            .listRowSeparatorTint(Color.orange)
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
                
                // Example images for dog
                //let remoteDogImage = "https://images.dog.ceo/breeds/labrador/lab_young.JPG"
                
                // Load an image from the endpoint
                await loadNewImage()
                
                print("I tried to load a new image")
                
                //load favourites from saved file
                loadFavourites()
                
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .active{
                    print("Active")
                } else {
                    print("Background")
                    
                    //permanently save the favourite list
                    persistFavourites()
                }
            }
            .navigationTitle("Dogs 🐶")
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
            currentImageURL = try JSONDecoder().decode(DogImage.self, from: data)
            
            //put the message in the structure into a URL
            currentImage = URL(string: currentImageURL.message)!
            
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
        persistFavourites()
    }
    
    //save data permanently
    func persistFavourites() {
        //get a location to save data
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouriteDogsLabel)
        print(filename)
        
        //try to encodr data to JSON
        do {
            let encoder = JSONEncoder()
            
            //configure the encoder to "pretty print" the JSON
            encoder.outputFormatting = .prettyPrinted
            
            //Encode the list of favourites
            let data = try encoder.encode(favourites)
            
            //write JSON to a file in the filename location
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            
            //see the data
            print("Save data to the document directory successfully.")
            print("=========")
            print(String(data: data, encoding: .utf8)!)
            
        } catch {
            print("Unable to write list of favourites to the document directory")
            print("=========")
            print(error.localizedDescription)
        }
    }
    
    //function for reloading the list of favourites
    func loadFavourites() {
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouriteDogsLabel)
        print(filename)
        
        do {
            //load raw data
            let data = try Data(contentsOf: filename)
            
            print("Save data to the document directory successfully.")
            print("=========")
            print(String(data: data, encoding: .utf8)!)
            
            //decode JSON into Swift native data structures
            //NOTE: [] are used since we load into an array
            favourites = try JSONDecoder().decode([DogImage].self, from: data)
            
        } catch {
            print("Could not loas the data from the stored JSON file")
            print("=========")
            print(error.localizedDescription)
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
