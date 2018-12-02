//
//  Musica.swift
//  Guitar Patterns
//
//  Created by Alberto Banet Masa on 27/11/2018.
//  Copyright © 2018 Alberto Banet Masa. All rights reserved.
//

import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer!

func playBackgroundMusic(filename: String) {
    let resourceUrl = Bundle.main.url(forResource: filename, withExtension: nil)
    guard let url = resourceUrl else {
        print("No se pudo encontrar fichero: \(filename)")
        return
    }
    
    do {
        try backgroundMusicPlayer = AVAudioPlayer(contentsOf: url)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    } catch {
        print("No se pudo crear audio player!")
        return
    }
}
