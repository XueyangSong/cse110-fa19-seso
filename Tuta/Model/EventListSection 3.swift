//
//  EventListSection.swift
//  Tuta
//
//  Created by Zhen Duan on 11/23/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation

enum EventListSection: Int, CaseIterable, CustomStringConvertible {
    
    case requested
    case inProgress
    case finished
    
    var description: String {
        switch self {
        case .requested:
            return "Requested"
        case .inProgress:
            return "In Progress"
        case .finished:
            return "Finished"
        }
    }
}

