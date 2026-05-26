//
//  Item.swift
//  ToDo List
//
//  Created by Upendra Kumar Yadav on 27/05/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
