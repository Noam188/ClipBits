
import Foundation

import AVFoundation
import Combine
import SwiftUI

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()

    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }

    var audioPlayer: AVAudioPlayer!

    func createAudioPlayer(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()

        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
        } catch {
            print("Failed to create audio player.")
        }
    }

    func startPlayback() {
        let playbackSession = AVAudioSession.sharedInstance()

        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }

        audioPlayer.play()
        isPlaying = true
    }

    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }

    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }

    func changeLoop(_ num: Int) {
        if let audioPlayer = audioPlayer {
            audioPlayer.numberOfLoops = num
        } else {
            print("Start recording has not been called yet")
        }
    }
}
