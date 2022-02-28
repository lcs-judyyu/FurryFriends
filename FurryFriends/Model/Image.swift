//
//  Image.swift
//  FurryFriends
//
//  Created by Judy Yu on 2022-02-28.
//

import Foundation

struct CatImage: Decodable, Hashable, Encodable {
    let file: String
}

struct DogImage: Decodable, Hashable, Encodable {
    let message: String
}
