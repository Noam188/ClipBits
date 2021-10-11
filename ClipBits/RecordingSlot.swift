import SwiftUI

struct ButtonSlot: View {
    @Binding var slot: Slot
    @Binding var canRecord: Bool /// whether recording is enabled for all slots
    @Binding var oneIsRecording: Bool /// whether 1 slot is recording (disable recording for other slots)
    @Binding var oneIsTrimming: Bool
    @Binding var edit: Bool
    @Binding var trim: Bool
    @Binding var anim: Bool
    @State private var fade = false
    @State private var fade2 = false
    @State var beenTrimmed = false
    @State var width: CGFloat = 0
    @State var width1: CGFloat = UIScreen.main.bounds.width / 3 - 45
    @State var totalWidth = UIScreen.main.bounds.width / 3 - 45
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder: AudioRecorder
    var index: Int
    func getValue(val:CGFloat)->String{
        return String(format: "%.2f", val)
    }
    var body: some View{
        VStack{
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
                    slot.beenRecorded = true
                    UserDefaults.standard.set(true, forKey: slot.id)
                    self.audioRecorder.startRecording(recordingName: "\(index)")
                    
                }
                if trim && oneIsTrimming == false{
                    beenTrimmed = true
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
                if trim == true{
                    if slot.isTrimming{
                        if let recording = audioRecorder.recordings.first(where: { $0.fileURL.lastPathComponent == "\(index).m4a" }) {
                            self.audioPlayer.startPlayback(audio: recording.fileURL)
                        }
                    }
                    else if oneIsTrimming {
                        print("One slot is already trimming")
                    }
                    else{
                        slot.isTrimming = true
                        oneIsTrimming = true
                    }
                    
                    
                    
                }
            }) {
                VStack{
                    ZStack{
                            Rectangle()
                                .cornerRadius(20)
                                .foregroundColor(.gray)
                        if canRecord && oneIsRecording == false || slot.isRecording{
                            Rectangle()
                                .cornerRadius(20)
                                .foregroundColor(.red)
                                .onAppear(){
                                    withAnimation(Animation.easeIn(duration: 0.6).repeatForever(autoreverses: true)){
                                        fade2.toggle()
                                    }
                                }.opacity(fade2 ? 0 : 1)
                        }

                        if trim && oneIsTrimming == false && slot.beenRecorded == true{
                            Rectangle()
                                .cornerRadius(20)
                                .foregroundColor(.yellow)
                                .onAppear(){
                                    withAnimation(Animation.easeIn(duration: 0.6).repeatForever(autoreverses: true)){
                                        fade.toggle()
                                    }
                                }.opacity(fade ? 0 : 1)
                        }
                        if slot.beenRecorded == true{
                            Image(systemName: "waveform.path")
                                .foregroundColor(.black)
                                .font(.system(size: 60))
                        }
                    }
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
            if trim && slot.isTrimming{
                ZStack(alignment:.leading){
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height:6)
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: self.width1 - self.width ,height:6)
                        .offset(x: width + 18)
                    HStack(spacing: 0){
                        Circle()
                            .foregroundColor(.yellow)
                            .frame(width: 18, height: 18)
                            .offset(x: self.width)
                            .gesture(
                                DragGesture()
                                    .onChanged({ (value) in
                                        if value.location.x >= 0 && value.location.x <= self.width1{
                                            self.width = value.location.x
                                        }
                                    })
                            )
                        Circle()
                            .foregroundColor(.yellow)
                            .frame(width: 18, height: 18)
                            .offset(x: self.width1)
                            .gesture(
                                DragGesture()
                                    .onChanged({ (value) in
                                        if value.location.x <= self.totalWidth && value.location.x >= self.width{
                                            self.width1 = value.location.x
                                        }
                                    })
                            )
                    }
                }
            }
        }
    }
}
