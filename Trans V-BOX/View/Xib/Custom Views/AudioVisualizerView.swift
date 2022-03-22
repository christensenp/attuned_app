//
//  AudioVisualizerView.swift
//  VoiceMemosClone
//
//  Created by Hassan El Desouky on 1/12/19.
//  Copyright © 2019 Hassan El Desouky. All rights reserved.
//

import UIKit

class AudioVisualizerView: UIView {

    // Bar width
    var barWidth: CGFloat = 6.0
    // Indicate that waveform should draw active/inactive state
    var active = false {
        didSet {
            if self.active {
                self.color = UIColor.red.cgColor
            }
            else {
                self.color = UIColor.gray.cgColor
            }
        }
    }
    // Color for bars
    var color = UIColor.gray.cgColor
    // Given waveforms
    var waveforms: [Int] = Array(repeating: 0, count: 300)
    // MARK: - Init
    override init (frame : CGRect) {
        super.init(frame : frame)
        let count =  Int((SCREEN_WIDTH - 8) / self.barWidth) * 2
        self.waveforms = Array(repeating: 0, count: count + 10)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.backgroundColor = UIColor.clear
    }
    
    // MARK: - Draw bars
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.clear(rect)
        context.setFillColor(red: 0, green: 0, blue: 0, alpha: 0)
        context.fill(rect)
        context.setLineWidth(3)
        context.setLineCap(.round)
        context.setStrokeColor(self.color)
        context.setBlendMode(.normal)
        let h = rect.size.height
        let m = h / 2
        let r = self.barWidth / 2
        let x = m - r
        var bar: CGFloat = 0
        for i in 0 ..< self.waveforms.count {
            var v = h * CGFloat(self.active ? self.waveforms[i] : 0) / 70.0
            if v > x {
                v = x
            }
            else if v < 3 {
                v = 3
            }
            let oneX = bar * self.barWidth
            var oneY: CGFloat = 0
            if i % 2 == 1 {
                oneY = m - v
            } else {
                oneY = m + v
            }
            context.move(to: CGPoint(x: oneX, y: m))
            context.addLine(to: CGPoint(x: oneX, y: oneY))
            context.strokePath()
            if i % 2 == 1 {
                bar += 1
            }
        }
    }
}
