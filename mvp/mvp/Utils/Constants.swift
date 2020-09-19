//
//  Constants.swift
//  mvp
//
//  Created by Ankit Sabharwal on 19/09/20.
//  Copyright © 2020 Ankit Sabharwal. All rights reserved.
//

import Foundation

enum ActionType: String {
    case add = "Add"
    case update = "Update"
    case delete = "Delete"
    case favourite = "Favourite"
}

class Constants {
    enum Route: String {
        case AddScreen
        case UpdateScreen
        case DeleteScreen
    }
}
