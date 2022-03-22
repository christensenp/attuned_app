
//  CollectionExtension.swift
//  Trans V-BOX
//  Created by Trans V-BOX on 23/02/2020.
//  Copyright © 2020 Trans V-BOX. All rights reserved.


import UIKit

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
