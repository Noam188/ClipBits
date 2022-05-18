//
//  Timer.swift
//  ClipBits
//
//  Created by Noam Elyashiv on 27/03/2022.
//
import AVKit
import SwiftUI

struct TimerWatch: View{
    @StateObject var audioRecorder = AudioRecorder()
    @EnvironmentObject var stopWatchManager:StopWatchManager
    @Binding var oneIsRecording:Bool/// if one slot is recording
    @Binding var num: CGFloat
    @Binding var slots:[Slot]
    @Binding var canRecord:Bool
    @Binding var metronome:Bool
    @State var audioPlayer: AVAudioPlayer!
    var body: some View {
        Circle()
            .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .frame(width: radius * 2, height: radius * 2)
            .opacity(stopWatchManager.countDown ? 1 : 0)
            .animation(.easeInOut)
            .animation(.easeOut)
        
        
        Circle()
            .trim(from: 0, to: 1 - (num - CGFloat(stopWatchManager.secondsElapsed)) / num)
            .stroke((CGFloat(stopWatchManager.secondsElapsed) > (num / 3 + num / 3)) ?
                    Color.green :
                        (CGFloat(stopWatchManager.secondsElapsed) > (num / 3)) ?
                    Color.yellow : Color.red,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .rotationEffect(.degrees(-90))
            .animation(.easeInOut)
            .opacity(oneIsRecording ? 1 : 0)
            .animation(.easeInOut)
            .animation(.easeOut)
            .scaleEffect(oneIsRecording ? 1 : 0)
            .animation(.easeIn)
            .frame(width: radius * 2, height: radius * 2)
        
        //    .opacity{stopWatchManager.stopCount ? 0 : 1 }
        VStack {
            Text(stopWatchManager.countDown ? "\(stopWatchManager.secondsElapsed)" : "\(stopWatchManager.displaySeconds)" )
                .font(.largeTitle)
            if !stopWatchManager.countDown{
                Button(action: {
                    canRecord.toggle()
                    self.stopWatchManager.stop()
                    for index in slots.indices {
                        if slots[index].isRecording {
                            slots[index].isRecording = false
                            self.audioRecorder.stopRecording()
                        }
                    }
                    oneIsRecording = false
                }) {
                    Text("Stop Recording")
                        .font(.system(size: 20))
                        .fontWeight(.thin)
                        .shadow(color: .blue, radius: 2)
                }
                .padding()
            }
        }
        .onChange(of: stopWatchManager.stopWatchSeconds) { _ in
            if metronome{
            print("hello")
            let sound = Bundle.main.path(forResource: "Click", ofType: "mp3")
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            self.audioPlayer.play()
            }
            if stopWatchManager.stopWatchSeconds == 1{
                for index in slots.indices {
                    if slots[index].isRecording {
                        self.audioRecorder.startRecording(recordingName: "\(index)")
                    }
                }
            }
            if (stopWatchManager.stopWatchSeconds-1)/stopWatchManager.numberOfMeasures == 4 && stopWatchManager.autoStop{
                canRecord.toggle()
                self.stopWatchManager.stop()
                for index in slots.indices {
                    if slots[index].isRecording {
                        slots[index].isRecording = false
                        self.audioRecorder.stopRecording()
                    }
                }
                oneIsRecording = false
            }
        }
        .opacity(oneIsRecording ? 1 : 0.0) /// don't use 0
        .animation(.easeInOut)
        .animation(.easeOut)
    }
}

