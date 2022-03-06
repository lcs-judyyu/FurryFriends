//
//  FavouritesTitleView.swift
//  FurryFriends
//
//  Created by Judy Yu on 2022-03-06.
//

import SwiftUI

struct FavouritesTitleView: View {
    var body: some View {
        HStack {
            Text("Favourites")
                .bold()
                .padding(.leading)
                .padding(.bottom, 10)
            
            Spacer()
        }
    }
}

struct FavouritesTitleView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesTitleView()
    }
}
