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
                    
                    DogView()
                }
                .tabItem {
                    Image(systemName: "pawprint")
                    Text("🐶")
                }
                
                NavigationView {
                    CatView()
                }
                .tabItem {
                    Image(systemName: "pawprint.circle")
                    Text("🐱")
                }
                
            }
        }
    }
}
