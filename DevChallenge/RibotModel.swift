//
//  RibotModel.swift
//  DevChallenge
//
//  Created by Armands Mikanovskis on 26/06/2017.
//  Copyright © 2017 Mikanovskis, Armands. All rights reserved.
//

import Foundation

struct Ribot {
    let id: String
    let email: String
    let avatar: String
    let dateOfBirth: String
    let hexColor: String
    let bio: String
    let isActive: Bool
    let name : RibotName
}
struct RibotName {
    let first: String
    let last: String
}
