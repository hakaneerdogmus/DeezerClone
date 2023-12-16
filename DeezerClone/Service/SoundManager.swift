//
//  SoundManager.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static let shared = SoundManager()
    
    var audioPlayer: AVPlayer?

    func playSound(sound: String){
        if let url = URL(string: sound) {
            self.audioPlayer = AVPlayer(url: url)
            print(url)
        }
    }
}
