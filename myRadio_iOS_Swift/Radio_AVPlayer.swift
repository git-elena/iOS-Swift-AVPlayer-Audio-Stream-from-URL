//
//  File.swift
//  myRadio_iOS_Swift
//
//  Created by Add on 17.07.2021.
//

import Foundation
import MediaPlayer

enum PlayerStatus {
    case playing
    case stoped
}

class Radio_AVPlayer {
    static let radioPlayer = Radio_AVPlayer()
    
    /// Toggle Radio playing
    public func didToggle() {
        switch self.status {
            case .playing: pause()
            case .stoped:  play()
        }
    }
    
    /// Play Radio
    public func play() {
        self.player.play()
        self.audioSession.on()
        self.status = .playing
    }
    
    /// Pause Radio (needed continue when interrupted audio session)
    private func pause(neededContinue: Bool = false) {
        self.player.pause()
        if !neededContinue {
            self.status = .stoped
            self.audioSession.off()
        }
    }
    
    /// Resume Radio (after interrupted audio session)
    public func resume() {
        if status == .playing {
            self.player.play()
        }
    }
    
    /// The player current radio URL
    public var radioURL: URL? {
        didSet {
            didChangeRadioURL(with: radioURL)
        }
    }
    
    deinit {
        resetPlayer()
    }
    
    /// Current Player
    private let player = AVPlayer()
    
    /// Current Player's state
    private var status = PlayerStatus.stoped
    
    /// Default AVAudioSession
    private let audioSession = AudioSession()
    
    // MARK: - Private helper
    
    private func didChangeRadioURL(with url: URL?) {
        guard let url = url else { return }
        self.resetPlayer()
        self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
        
    }
    
    private func resetPlayer() {
        pause()
        player.replaceCurrentItem(with: nil)
    }
}

extension AVPlayer {
    
    var isPlaying: Bool {
        if (self.timeControlStatus == .playing ) {
            return true
        } else {
            return false
        }
    }
    
}

private class AudioSession {
    private let instance = AVAudioSession.sharedInstance()
    private var isSet: Bool
    
    init() {
        do {
            try self.instance.setCategory(.playback, mode: AVAudioSession.Mode.default, options: [])
            isSet = true
        } catch {
            isSet = false
        }
    }
    
    func on() {
        guard isSet else { return }
        try? self.instance.setActive(true)
    }
    
    func off() {
        guard isSet else { return }
        try? self.instance.setActive(false, options: .notifyOthersOnDeactivation)
    }
}
