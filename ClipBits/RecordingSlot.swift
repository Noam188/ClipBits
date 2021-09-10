
import SwiftUI

struct ButtonSlot: View {
    @Binding var slot: Slot
    @Binding var canRecord: Bool /// whether recording is enabled for all slots
    @Binding var oneIsRecording: Bool /// whether 1 slot is recording (disable recording for other slots)
    @State var beenRecorded = false
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder: AudioRecorder
    var index: Int
    
    var body: some View{
        Button(action:{
            if canRecord == false{
                if audioPlayer.isPlaying == false {
                    
                    if let recording = audioRecorder.recordings.first { $0.fileURL.lastPathComponent == "\(index).m4a" } {
                        self.audioPlayer.startPlayback(audio: recording.fileURL)
                    } else {
                        print("No audio url was saved")
                    }
                }
            }
            if canRecord {
                self.audioRecorder.startRecording(recordingName: "\(index)")
                beenRecorded = true
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
                
                if beenRecorded == true{
                    Image(systemName: "waveform.path")
                        .foregroundColor(.black)
                        .font(.system(size: 60))
                }
            }
        }
    }
}

