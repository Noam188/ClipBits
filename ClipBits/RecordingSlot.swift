
import SwiftUI

struct ButtonSlot: View {
    @Binding var slot: Slot
    @Binding var canRecord: Bool /// whether recording is enabled for all slots
    @Binding var oneIsRecording: Bool /// whether 1 slot is recording (disable recording for other slots)
    @State var beenRecorded = false
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder: AudioRecorder
    var audioURL: URL
    
    var body: some View{
        ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
            RecordingRow(audioURL: recording.fileURL)
        }
        Button(action:{
            if canRecord == false{
                if audioPlayer.isPlaying == false {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }
            }
            if canRecord {
                self.audioRecorder.startRecording()
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

