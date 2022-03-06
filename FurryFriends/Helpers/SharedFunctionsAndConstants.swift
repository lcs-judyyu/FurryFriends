//
//  SharedFunctionsAndConstants.swift
//  FurryFriends
//
//  Created by Judy Yu on 2022-03-05.
//

import Foundation

//return the location of the Documents directory for the app
func getDocumentsDirectory() -> URL{
    let paths = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
    
    //return the first path
    return paths[0]
}

//define filename that we will write data to in the directory
let savedFavouriteDogsLabel = "savedFavouriteDogs"

let savedFavouriteCatsLabel = "savedFavouriteCats"
