//
//  FurryFriendsApp.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

@main
struct FurryFriendsApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    ZStack {
                        DogView()
                        
                        VStack {
                            Spacer()
                                .frame(maxHeight: .infinity)
                            
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 10)
                                .background(Color.orange.opacity(0.2))
                        }
                    }
                }
                .tabItem {
                    Image(systemName: "pawprint")
                    Text("Dogs")
                }
                
                NavigationView {
                    ZStack {
                        CatView()
                        
                        VStack {
                            Spacer()
                                .frame(maxHeight: .infinity)
                            
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 10)
                                .background(Color.orange.opacity(0.2))
                        }
                    }
                }
                .tabItem {
                    Image(systemName: "pawprint.fill")
                    Text("Cats")
                }
                
            }
        }
    }
}
