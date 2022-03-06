//
//  QuizView.swift
//  FurryFriends
//
//  Created by Judy Yu on 2022-03-06.
//

import SwiftUI

struct QuizView: View {
    
    // MARK: Stored properties
    @State var currentDogImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    
    @State var currentCatImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    
    @State var currentDogImageURL: DogImage = DogImage(message: "")
    
    @State var currentCatImageURL: CatImage = CatImage(file: "")
    
    @State var currentDogImageSelected: Bool = false
    
    @State var currentCatImageSelected: Bool = false
    
    @State var startQuiz: Bool = false
    
    @State var questionNumber: Int = 0
    
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("🐕  🐩")
                    .font(.system(size: 80))
                
                //button to start the quiz
                Button(action: {
                   startQuiz = true
                    
                }, label: {
                    Text("Start Quiz")
                        .font(.largeTitle)
                })
                    .buttonStyle(GrowingButton())
                    .padding(.vertical, 40)
                
                Text("🐈  🐈‍⬛")
                    .font(.system(size: 80))
            }
            .padding(.bottom, 20)
            .opacity(startQuiz == false ? 1.0 : 0.0)
            
            VStack {
                RemoteImageView(fromURL: currentDogImage)
                    .padding(15)
                    .border(currentDogImageSelected == true ? Color("pinkLike") : Color("pinkNotLike"), width: 4)
                    .onTapGesture {
                        currentDogImageSelected = true
                        currentCatImageSelected = false
                    }
                
                RemoteImageView(fromURL: currentCatImage)
                    .padding(15)
                    .border(currentCatImageSelected == true ? Color("pinkLike") : Color("pinkNotLike"), width: 4)
                    .onTapGesture {
                        currentCatImageSelected = true
                        currentDogImageSelected = false
                    }
            }
            .padding(.bottom, 20)
            .opacity(startQuiz == true ? 1.0 : 0.0)
            
            VStack {
                Text("")
            }
        }
        .task {
            await loadNewDogImage()
            
            await loadNewCatImage()
        }
        .navigationTitle("🐶 or 🐱 ?")
    }
    // MARK: Functions
    //create a funtion to load new dog image
    func loadNewDogImage() async {
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
            currentDogImageURL = try JSONDecoder().decode(DogImage.self, from: data)
            
            //put the message in the structure into a URL
            currentDogImage = URL(string: currentDogImageURL.message)!
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
        
    }
    
    //create a funtion to load new cat image
    func loadNewCatImage() async {
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
            currentCatImageURL = try JSONDecoder().decode(CatImage.self, from: data)
            
            //put the file in the structure into a URL
            currentCatImage = URL(string: currentCatImageURL.file)!
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
        
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QuizView()
        }
    }
}
