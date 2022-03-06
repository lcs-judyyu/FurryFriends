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
                
                DogView()
                    .tabItem {
                        Text("🐶")
                    }
                
                CatView()
                    .tabItem {
                        Text("🐱")
                    }
            }
        }
    }
}
