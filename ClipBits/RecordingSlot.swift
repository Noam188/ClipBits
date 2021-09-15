
import SwiftUI

struct ButtonSlot: View {
    @Binding var slot: Slot
    @Binding var canRecord: Bool /// whether recording is enabled for all slots
    @Binding var oneIsRecording: Bool /// whether 1 slot is recording (disable recording for other slots)
    @Binding var edit: Bool
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder: AudioRecorder
    var index: Int
    var body: some View{
        Button(action:{
            if canRecord == false && edit == false && slot.beenRecorded == true{
                if let recording = audioRecorder.recordings.first(where: { $0.fileURL.lastPathComponent == "\(index).m4a" }) {
                    self.audioPlayer.startPlayback(audio: recording.fileURL)
                } else {
                    print("No audio url was saved")
                }
                if audioPlayer.isPlaying == false {
                  print("audio is playing")
                }
            }
            if canRecord && oneIsRecording == false{
                UserDefaults.standard.set(true, forKey: slot.id.uuidString)
                self.audioRecorder.startRecording(recordingName: "\(index)")
                
            }
            if canRecord {
                if slot.isRecording {
                    self.audioRecorder.stopRecording()
                    slot.isRecording = false
                    oneIsRecording = false
                    canRecord = false
                }
                else if oneIsRecording {
                    print("One slot is already recording")
                }
                else {
                    slot.isRecording = true
                    oneIsRecording = true
                }
            }
        }) {
            VStack{
                ZStack{
                    Rectangle()
                        .cornerRadius(20)
                        .foregroundColor(
                            (canRecord && (!oneIsRecording || slot.isRecording))
                                ? .red
                                : .gray
                        )
                        .animation(
                            (canRecord && (!oneIsRecording || slot.isRecording))
                                ? Animation.default.repeatForever(autoreverses: true)
                                : .default, /// stop animation if `canRecord` is false
                            value: (canRecord && (!oneIsRecording || slot.isRecording)) /// whenever this changes from True to False or vice versa, the animation will update
                        )
                    
                    
                    if slot.beenRecorded == true{
                        Image(systemName: "waveform.path")
                            .foregroundColor(.black)
                            .font(.system(size: 60))
                    }
                }
                if edit == true {
                    Button(action:{
                        slot.isChecked.toggle()
                    }) {
                        Image(systemName: slot.isChecked ? "checkmark.circle.fill" : "checkmark.circle")
                            .font(.system(size:30))
                    }
                }
                
            }
        }
    }
}

