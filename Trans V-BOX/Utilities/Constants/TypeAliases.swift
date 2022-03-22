
//  TypeAliases.swift
//  Trans V-BOX
//  Created by Trans V-BOX on 23/01/2020.
//  Copyright © 2020 Trans V-BOX. All rights reserved.


import Foundation
import UIKit
import StoreKit

typealias EmptyAction = ()->()
typealias StringCompletion = (_ text: String) -> ()
typealias CompletionWithStatus = (Bool) -> ()
typealias ProgressClosure = (_ progress: Float) -> ()
typealias ImageClosure = (_ image: UIImage?) -> ()
typealias SelectionClosure = (_ indexPath: IndexPath) -> ()
typealias SLAlertCompletion = (_ text: String, _ alert: Any) -> ()
typealias VideoStatusClosure = (VideoStatus) -> ()
