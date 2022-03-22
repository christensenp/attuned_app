//
//  ViewController.swift
//  Example
//
//  Created by gary on 17/05/2016.
//  Copyright © 2016 Gary Newby. All rights reserved.
//

import UIKit
import AVFoundation

class AudioEngine {
    
    private let engine = AVAudioEngine()
    private(set) var sampler = AVAudioUnitSampler()
    private let reverb = AVAudioUnitReverb()
    private let delay = AVAudioUnitDelay()

    func start() {
        engine.attach(sampler)
        //engine.attach(reverb)
         engine.attach(delay)
        sampler.volume = 10.0

        engine.connect(sampler, to: delay, format: nil)
        //engine.connect(delay, to: reverb, format: nil)
        engine.connect(delay, to: engine.mainMixerNode, format: nil)

        // Reverb
        reverb.loadFactoryPreset(.largeHall)
        reverb.wetDryMix = 30.0

        // Delay
        delay.wetDryMix = 1.0
        delay.delayTime = 0.10
        delay.feedback = 10.0
        delay.lowPassCutoff = 16000.0

        if engine.isRunning {
            print("Audio engine already running")
            return
        }
        do {
            try engine.start()
            print("Audio engine started")
        } catch {
            print("Error: couldn't start audio engine")
            return
        }

        let audioSession = AVAudioSession.sharedInstance()
       
        if #available(iOS 10.0, *) {
            try! AVAudioSession.sharedInstance().setCategory(.playback, mode:  AVAudioSession.Mode.measurement)
        } else {
            // Workaround until https://forums.swift.org/t/using-methods-marked-unavailable-in-swift-4-2/14949 is fixed
            AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.CategoryOptions.mixWithOthers)
        }

        do {
            try audioSession.setActive(true)
        } catch {
            print("Error: AudioSession couldn't set category active")
            return
        }
    }

    func stop() {
        engine.stop()
    }
}
