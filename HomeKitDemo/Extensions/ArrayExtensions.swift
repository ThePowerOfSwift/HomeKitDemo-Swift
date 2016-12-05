//
//  ArrayExtensions.swift
//  HomeKitDemo
//
//  Created by Vlad on 11/27/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

