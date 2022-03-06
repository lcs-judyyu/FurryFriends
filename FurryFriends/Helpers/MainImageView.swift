//
//  MainImageView.swift
//  FurryFriends
//
//  Created by Judy Yu on 2022-03-06.
//

import SwiftUI

struct MainImageView: View {
    
    //MARK: Stored Properties
    let currentImage: URL
    
    @Binding var currentImageAddedToFavourites: Bool
    
    var body: some View {
        
        // Shows the main image
        RemoteImageView(fromURL: currentImage)
            .padding(15)
            .border(currentImageAddedToFavourites == true ? Color("pinkLike") : Color("pinkNotLike"), width: 4)
    }
}

struct MainImageView_Previews: PreviewProvider {
    
    static let example = URL(string: "https://picsum.photos/640/360")!
    
    static var previews: some View {
        MainImageView(currentImage: example, currentImageAddedToFavourites: .constant(true))
    }
}
