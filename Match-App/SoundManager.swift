//
//  SoundManager.swift
//  Match-App
//
//  Created by Dan Kass on 3/27/19.
//  Copyright © 2019 Couchguy Labs. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    static func playSound(_ effect:SoundEffect){
        var soundFilename = ""
        
        // Determine which sound effect we want to play and set the filename
        switch effect {
            case .flip:
                soundFilename = "cardflip"
            case .shuffle:
                soundFilename = "shuffle"
            case .match:
                soundFilename = "dingcorrect"
            case .nomatch:
                soundFilename = "dingwrong"
        }
        
        // Get path of sound file
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        guard bundlePath != nil else {
            print("Couldn't find sound file name, \(soundFilename) in the bundle")
            return
        }
        
        // Create URL object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            // Create Audio PLayer Ojbect
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // Play the sound
            audioPlayer?.play()
        } catch {
            // Couldn't Create audio player object, log error
            print("Couldn't Create the audio player object for: \(soundFilename)")
        }
    }
    
}
