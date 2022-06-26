import SwiftUI
import AVFoundation
struct ButtonSlot: View {
    @State var audioPlayer2: AVAudioPlayer!
    @EnvironmentObject var stopWatchManager:StopWatchManager
    @Binding var slot: Slot
    @Binding var canRecord: Bool /// whether recording is enabled for all slots
    @Binding var oneIsRecording: Bool /// whether 1 slot is recording (disable recording for other slots)
    @Binding var edit: Bool
    @Binding var loopState: Bool
    @State private var fade = false
    @State var isLooping = false
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder: AudioRecorder
    @State var openSheet = false
    @State var presetName:String? = nil
    var index: Int
    func getValue(val: CGFloat) -> String {
        return String(format: "%.2f", val)
    }
    
    var body: some View {
        VStack {
            Button(action: {
                if !canRecord, !edit, slot.beenRecorded == true {
                    if let recording = audioRecorder.recordings.first(where: { $0.fileURL.lastPathComponent == "\(index).m4a" }) {
                        self.audioPlayer.createAudioPlayer(audio: recording.fileURL)
                        print("yep")
                    } else {
                        print("No audio url was saved")
                    }
                    if isLooping{
                        self.audioPlayer.changeLoop(-1)
                    }
                    self.audioPlayer.startPlayback()
                    
                    if audioPlayer.isPlaying == false {
                        print("audio is playing")
                    }
                }
                if canRecord, oneIsRecording == false {
                    print("works")
                    slot.beenRecorded = true
                    stopWatchManager.start()
                    UserDefaults.standard.set(true, forKey: slot.id)
                    oneIsRecording = true
                    slot.isRecording = true
                }
                if presetName != nil{
                    let sound = Bundle.main.path(forResource: presetName, ofType: "mp3")
                    self.audioPlayer2 = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                    self.audioPlayer2.play()
                }
                if edit == true && slot.beenRecorded == false{
                   openSheet = true
                }
            }) {
                VStack {
                    ZStack {
                        Rectangle()
                            .cornerRadius(20)
                            .foregroundColor(.gray)
                        if canRecord && oneIsRecording == false || slot.isRecording {
                            Rectangle()
                                .cornerRadius(20)
                                .foregroundColor(.red)
                                .onAppear {
                                    withAnimation(Animation.easeIn(duration: 0.6).repeatForever(autoreverses: true)) {
                                        fade.toggle()
                                    }
                                }.opacity(fade ? 0 : 1)
                        }
                        if edit == true && slot.beenRecorded == false{
                            Image(systemName: "arrow.down")
                                .foregroundColor(.black)
                                .font(.system(size: 60))
                        }
                        if slot.beenRecorded == true && loopState == false{
                            Image(systemName: "waveform.path")
                                .foregroundColor(.black)
                                .font(.system(size: 60))
                        } else if loopState, slot.beenRecorded == true {
                                Text("∞")
                                    .foregroundColor(.black)
                                    .font(.system(size: 60))
                        } else if slot.beenRecorded == false && canRecord{
                            Image(systemName: "mic.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 60))
                        }
                    }
                }
            }.sheet(isPresented: $openSheet, content: {Presets(presetName: $presetName, openSheet: $openSheet)})
            if edit == true {
                Button(action: {
                    slot.isChecked.toggle()
                    print("toggled")
                }) {
                    Image(systemName: slot.isChecked ? "checkmark.circle.fill" : "checkmark.circle")
                        .font(.system(size: 30))
                }
            }
            if loopState == true {
                Toggle(isOn: $isLooping) {
                        Text("∞")
                            .font(.system(size: 20))
                            .foregroundColor((slot.beenRecorded == true) ? .black : .gray)
                            .disabled(slot.beenRecorded == false)
                    }
                }
            }
        }
    }

