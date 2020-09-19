//
//  IdeaModel.swift
//  mvp
//
//  Created by Ankit Sabharwal on 19/09/20.
//  Copyright © 2020 Ankit Sabharwal. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Idea: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var isFavourite: Bool
    @ServerTimestamp var creationDate: Timestamp?
    @ServerTimestamp var updatedDate: Timestamp?
}
