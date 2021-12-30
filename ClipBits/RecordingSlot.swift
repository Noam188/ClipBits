import SwiftUI

struct ButtonSlot: View {
    @Binding var slot: Slot
    @Binding var canRecord: Bool /// whether recording is enabled for all slots
    @Binding var oneIsRecording: Bool /// whether 1 slot is recording (disable recording for other slots)
    @Binding var oneIsTrimming: Bool
    @Binding var edit: Bool
    @Binding var trim: Bool
    @Binding var anim: Bool
    @Binding var isActive: Bool
    @Binding var loopState: Bool
    @State private var fade = false
    @State var beenTrimmed = false
    @State var width: CGFloat = 0
    @State var width1: CGFloat = UIScreen.main.bounds.width / 3 - 45
    @State var totalWidth = UIScreen.main.bounds.width / 3 - 45
    @State var isInfinite = false
    @State var numberofTimesLooped = 10
    @State var myInt = 3 //times being looped
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder: AudioRecorder
    var index: Int
    func getValue(val:CGFloat)->String{
        return String(format: "%.2f", val)
    }
    var body: some View{
        VStack{
            Button(action:{
                if !canRecord && !edit && slot.beenRecorded == true{
                    if isInfinite{
                        audioPlayer.changeLoop(-1)
                    }
                    else{
                        audioPlayer.changeLoop(myInt)
                    }
                    if let recording = audioRecorder.recordings.first(where: { $0.fileURL.lastPathComponent == "\(index).m4a" }) {
                        self.audioPlayer.startPlayback(audio: recording.fileURL)
                    }
                    
                    else {
                        print("No audio url was saved")
                    }
                    
                    if audioPlayer.isPlaying == false {
                        print("audio is playing")
                    }
                    
                }
                if canRecord && oneIsRecording == false{
                    slot.beenRecorded = true
                    UserDefaults.standard.set(true, forKey: slot.id)
                    isActive = true
                    oneIsRecording = true
                    slot.isRecording = true
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
                                        fade.toggle()
                                    }
                                }.opacity(fade ? 0 : 1)
                        }
                        
                        if slot.beenRecorded == true && loopState == false{
                            Image(systemName: "waveform.path")
                                .foregroundColor(.black)
                                .font(.system(size: 60))
                        }
                        else if loopState && slot.beenRecorded == true{
                            if !isInfinite{
                                Text("\(myInt)")
                                    .foregroundColor(.black)
                                    .font(.system(size: 60))
                            }
                            else{
                                Text("∞")
                                    .foregroundColor(.black)
                                    .font(.system(size: 60))
                            }
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
            if loopState == true {
                Toggle(isOn: $isInfinite){
                    Text("∞")
                        .font(.system(size: 30))
                        .foregroundColor((slot.beenRecorded == true) ? .black : .gray)
                }
                .disabled(slot.beenRecorded == false)
            }
        }
    }
}
