//
//  GradientView.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/28/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIControl {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear { didSet { updateView() }}
    @IBInspectable var secondColor: UIColor = UIColor.clear { didSet { updateView() }}
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0) { didSet { updateView() }}
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0.0, y: 0.0) { didSet { updateView() }}
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
    }
}
