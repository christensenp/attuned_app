//
//  PainoView.swift
//  Trans V-BOX
//
//  Created by Gourav on 20/04/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import AudioKit
import AudioToolbox
import AVKit

protocol PainoViewDelegate: class {
    func noteOn(note: UInt8, frequeny: Double)
    func noteOff(note: UInt8, frequeny: Double)
    func stopPaino()
    func createPaino()
}

class PainoView: UIView {
    
    @IBOutlet weak private var widthConstant: NSLayoutConstraint!
    //MARK: - White Keys -
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var f2WhiteView: GradientView!
    @IBOutlet weak var g2WhiteView: GradientView!
    @IBOutlet weak var a2WhiteView: GradientView!
    @IBOutlet weak var b2WhiteView: GradientView!
    @IBOutlet weak var c3WhiteView: GradientView!
    @IBOutlet weak var d3WhiteView: GradientView!
    @IBOutlet weak var e3WhiteView: GradientView!
    @IBOutlet weak var f3WhiteView: GradientView!
    @IBOutlet weak var g3WhiteView: GradientView!
    @IBOutlet weak var a3WhiteView: GradientView!
    @IBOutlet weak var b3WhiteView: GradientView!
    @IBOutlet weak var c4WhiteView: GradientView!
    @IBOutlet weak var d4WhiteView: GradientView!
    @IBOutlet weak var e4WhiteView: GradientView!
    
    @IBOutlet weak var containerView: UIView!
    //MARK: - Black Keys -
    @IBOutlet weak var f2BlackView: GradientView!
    @IBOutlet weak var g2BlackView: GradientView!
    @IBOutlet weak var b2BlackView: GradientView!
    @IBOutlet weak var c3BlackView: GradientView!
    @IBOutlet weak var d3BlackView: GradientView!
    @IBOutlet weak var f3BlackView: GradientView!
    @IBOutlet weak var g3BlackView: GradientView!
    @IBOutlet weak var b3BlackView: GradientView!
    @IBOutlet weak var c4BlackView: GradientView!
    @IBOutlet weak var d4BlackView: GradientView!
    
    //MARK: - Notes -
    
    @IBOutlet weak var f2NoteLabel: UILabel!
    @IBOutlet weak var g2NoteLabel: UILabel!
    @IBOutlet weak var a2NoteLabel: UILabel!
    @IBOutlet weak var b2NoteLabel: UILabel!
    @IBOutlet weak var c3NoteLabel: UILabel!
    @IBOutlet weak var d3NoteLabel: UILabel!
    @IBOutlet weak var e3NoteLabel: UILabel!
    @IBOutlet weak var f3NoteLabel: UILabel!
    @IBOutlet weak var g3NoteLabel: UILabel!
    @IBOutlet weak var a3NoteLabel: UILabel!
    @IBOutlet weak var b3NoteLabel: UILabel!
    @IBOutlet weak var c4NoteLabel: UILabel!
    @IBOutlet weak var d4NoteLabel: UILabel!
    @IBOutlet weak var e4NoteLabel: UILabel!
    
    @IBOutlet weak var idealFrequencyView: UILabel!
    @IBOutlet weak var topView: UIView!
    let topWhiteKeyColor = UIColor.colorWithRGB(r: 244, g: 244, b: 244)
    let bottomWhiteKeyColor = UIColor.colorWithRGB(r: 254, g: 254, b: 254)
    let topBlackKeyColor = UIColor.colorWithRGB(r: 2, g: 3, b: 3)
    let bottomBlackKeyColor = UIColor.colorWithRGB(r: 103, g: 103, b: 102)
    let activeColor = UIColor.red
    var idealMinFrequency: Double!
    var idealMaxFrequency: Double!
    var isRecording: Bool = false
    private var minIndex: Int = 0
    private var maxIndex: Int = 0
    var freqs = [Double]()
    let audioEngine = AudioEngine()
    @IBOutlet weak var targetImageView: UIImageView!
    weak var delegate: PainoViewDelegate?
    
    var oscillator = AKOscillator()
    private var keys: [GradientView] {
        get {
            [f2WhiteView, f2BlackView, g2WhiteView, g2BlackView, a2WhiteView, b2BlackView, b2WhiteView, c3WhiteView, c3BlackView, d3WhiteView, d3BlackView, e3WhiteView, f3WhiteView, f3BlackView, g3WhiteView, g3BlackView, a3WhiteView, b3BlackView, b3WhiteView, c4WhiteView, c4BlackView, d4WhiteView, d4BlackView, e4WhiteView]
        }
    }
    var players = [AVAudioPlayer]()
    private var blackKeys: [GradientView] {
        get {
            [f2BlackView, g2BlackView, b2BlackView, c3BlackView, d3BlackView, f3BlackView, g3BlackView, b3BlackView, c4BlackView, d4BlackView]
        }
    }
    class func instanceFromNib() -> PainoView {
        return UINib(nibName: "PainoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PainoView
    }

    override func layoutSubviews() {

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        idealFrequencyView.adjustsFontSizeToFitWidth = true
        keys.forEach { (view) in
            let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapGesture(_ :)))
            tapGesture.minimumPressDuration = 0
            view.addGestureRecognizer(tapGesture)
            // view.addTarget(self, action: #selector(touchUp(_:)), for: .valueChanged)
            //view.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        }
    }

    func setKeysWidth() {
        self.players = []
        for i in 0..<keys.count {
            let path = Bundle.main.path(forResource:"\(i)", ofType:"m4a")!   //let path = Bundle.main.path(forResource:"\(i)", ofType:"mp3")!
            let url = URL(fileURLWithPath: path)
            if let player = try? AVAudioPlayer(contentsOf: url) {
                player.setVolume(0.5, fadeDuration: 1)
                self.players.append(player)
            }
        }
        let width = (SCREEN_WIDTH - 21) / CGFloat(14)
        self.widthConstant.constant = width //> 26 ? width : 26
        setIdealViewPosition(freqs: freqs, idealMinFrequency: idealMinFrequency, idealMaxFrequency: idealMaxFrequency)
    }
    
    func reloadData(index: Int) {
        let value = index + 100
        for view in keys {
            view.startPoint = CGPoint(x: 0.5, y: 0)
            view.endPoint = CGPoint(x: 0.5, y: 1)
            if view.tag == value {
                view.firstColor = isIdealView(view: view) ?  UIColor.colorWithRGB(r: 255, g: 111, b: 59) : UIColor.colorWithRGB(r: 163, g: 149, b: 228)
                view.secondColor = isIdealView(view: view) ? UIColor.colorWithRGB(r: 250, g: 135, b: 82) : UIColor.colorWithRGB(r: 194, g: 183, b: 245)
            } else {
                view.firstColor = isBlackKey(view: view) ? topBlackKeyColor : topWhiteKeyColor
                view.secondColor = isBlackKey(view: view) ? bottomBlackKeyColor : bottomWhiteKeyColor
            }
            view.updateView()
        }
    }
    
    func isBlackKey(view: GradientView) -> Bool {
        if let _ = blackKeys.firstIndex(where: {$0.tag == view.tag}) {
            return true
        }
        return false
    }
    
    func isIdealView(view: GradientView) -> Bool{
        if view.tag >= self.minIndex && view.tag <= self.maxIndex {
            return true
        }
        return false
    }
    
    func setIdealViewPosition(freqs: [Double], idealMinFrequency: Double, idealMaxFrequency: Double)  {
        idealFrequencyView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0).isActive = true
        idealFrequencyView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2).isActive = true
        let nearestMinFrequency = getNearestFrequecy(forFrequency: idealMinFrequency, fromFrequencies: freqs)
        let nearestMaxFrequency = getNearestFrequecy(forFrequency: idealMaxFrequency, fromFrequencies: freqs)
        if let idealMinFrequencyindex = freqs.firstIndex(of: nearestMinFrequency), let minView = self.viewWithTag(100 + idealMinFrequencyindex), let idealMaxFrequencyIndex = freqs.firstIndex(of: nearestMaxFrequency), let maxView = self.viewWithTag(100 + idealMaxFrequencyIndex)  {
            self.minIndex = 100 + idealMinFrequencyindex
            self.maxIndex = 100 + idealMaxFrequencyIndex
            minView.updateConstraintsIfNeeded()
            maxView.updateConstraintsIfNeeded()
            self.layoutIfNeeded()
            idealFrequencyView.frame.origin.x = minView.frame.origin.x
            idealFrequencyView.frame.size.width = (maxView.frame.origin.x + maxView.frame.size.width) -  minView.frame.origin.x
            targetImageView.frame = CGRect(x: idealFrequencyView.frame.origin.x, y: idealFrequencyView.frame.origin.y - 38, width: idealFrequencyView.frame.size.width, height: 38)
        }
    }
    
    func getNearestFrequecy(forFrequency frequency: Double, fromFrequencies frequencies:[Double]) -> Double {
        var nearestFrequency: Double = frequencies.first ?? 0.0
        for freq in frequencies{
            if freq > frequency {
                nearestFrequency = freq
                break
            }
        }
        return nearestFrequency
    }

    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        if !isRecording {
            if let view = sender.view as? GradientView {
                if sender.state == .ended {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.reloadData(index: -1)
                        //self.player?.stop()
                       // self.audioEngine.sampler.stopNote(UInt8(101 + (view.tag-100)), onChannel: 0)
                    }
                } else if sender.state == .changed  {
                    print(view.tag)
                } else if sender.state == .began {
                    
                    let engine = AudioEngine()
                    engine.sampler
                    engine.start()
                    oscillator.start()
//                    engine.stop()
                    
                    let index = view.tag-100
                    self.reloadData(index: view.tag-100)
                    self.players[index].currentTime = 0
                    self.players[index].setVolume(10.0, fadeDuration:1)
                    self.players[index].prepareToPlay()
                    self.players[index].play()
                }
            }
        }
    }
}

