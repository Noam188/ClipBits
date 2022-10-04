import SwiftUI
import AVFoundation
struct Test{
    var num = 0
    var itiration = 0
}
struct ButtonSlot: View {
    @State var audioPlayer2: AVAudioPlayer!
    @State var test = Test()
    @EnvironmentObject var stopWatchManager:StopWatchManager
    @Binding var slot: Slot
    @Binding var canRecord: Bool /// whether recording is enabled for all slots
    @Binding var oneIsRecording: Bool /// whether 1 slot is recording (disable recording for other slots)
    @Binding var edit: Bool
    @Binding var loopState: Bool
    @Binding var oneIsLooping: Bool
    //backing track stuff
    @Binding var numOfLinks:Int
    @Binding var canLink:[Bool]
    //graphics variables
    @State var fade = false
    @State var fade2 = false
    // observed objects
    //    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var loopWatch = LoopWatch()
    @State var openSheet = false
    @Binding var tempo:Int
    // looping stuff
    @State var itiration = 0
    @State var num = 0
    var index: Int
    // functions
    func getValue(val: CGFloat) -> String {
        return String(format: "%.2f", val)
    }
    
    func quickAudio(){
        if slot.beenRecorded == true{
            if let recording = audioRecorder.recordings.first(where: { $0.fileURL.lastPathComponent == "\(index).m4a" }) {
                slot.audioPlayer.createAudioPlayer(audio: recording.fileURL)
                print("yep")
                slot.audioPlayer.startPlayback()
            } else {
                print("No audio url was saved")
            }
            if slot.audioPlayer.isPlaying == false {
                print("audio is playing")
            }
        }
        if slot.preset != ""{
            print(slot.preset)
            let sound = Bundle.main.path(forResource: slot.preset, ofType: "mp3")
            self.audioPlayer2 = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            self.audioPlayer2.play()
        }
    }
    var body: some View {
        ZStack{
            VStack {
                ZStack{
                    Button(action: {
                        if canRecord, oneIsRecording == false {
                            print("works")
                            slot.beenRecorded = true
                            stopWatchManager.start()
                            UserDefaults.standard.set(true, forKey: slot.id)
                            oneIsRecording = true
                            slot.isRecording = true
                        }
                    }) {
                        VStack {
                            ZStack {
                                Rectangle()
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                                    .shadow(radius: 3)
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
                            }
                        }
                    }.sheet(isPresented: $openSheet, content: {Presets(presetName: $slot.preset, openSheet: $openSheet)}).onReceive(slot.preset.publisher.first()){ _ in
                        UserDefaults.standard.set(slot.preset, forKey: "p\(slot.id)")
                    }
                    if slot.preset != "" || slot.beenRecorded == true{
                        ZStack{
                            Rectangle()
                                .cornerRadius(20)
                                .foregroundColor(.white)
                                .shadow(radius: 3)
                            if slot.preset != ""{
                                Image(slot.preset).resizable()
                                    .padding(.vertical)
                            }
                            if slot.beenRecorded == true{
                                Image(systemName: slot.isLooping ? "repeat" : "waveform")
                                    .foregroundColor((slot.isLooping && loopState) ? .green : .black)
                                    .font(.system(size: 60))
                            }
                        }
                        .blur(radius: edit || loopState ? 4 : 0)
                            .animation(.easeInOut)
                            .animation(.easeOut)
                            .gesture(LongPressGesture().onChanged { _ in
                                loopWatch.tempo = tempo
                                if loopState == false{
                                    if !slot.isLooping {
                                        quickAudio()
                                    }
                                }
                                if slot.isLooping{
                                    loopWatch.stop()
                                    loopWatch.start()
                                }
                            })
                            .onChange(of: loopWatch.secondsElapsed) { _ in
                                if loopWatch.isRunning{
                                    if slot.loopArr[itiration][num] == true{
                                        quickAudio()
                                    }
                                    if num == 31{
                                        if (itiration + 1) == slot.loopArr.count{
                                            itiration = 0
                                        } else {
                                            itiration += 1
                                        }
                                        num = 0
                                    } else {
                                        num += 1
                                    }
                                    
                                }
                            }
                    }
                }
                //            }
            }
            if edit == true {
                HStack(spacing:1){
                    if slot.preset != "" || slot.beenRecorded == true{
                        Button(action: {
                            audioRecorder.fetchRecording()
                            slot.preset = ""
                            UserDefaults.standard.set("", forKey: "p\(slot.id)")
                            slot.beenRecorded = false
                            UserDefaults.standard.set(false, forKey: "b\(slot.id)")
                            UserDefaults.standard.set(false, forKey: "l\(slot.id)")
                        }) {
                            Image(systemName: "trash.circle")
                                .font(.system(size: 40))
                                .foregroundColor(.red)
                                .background(Color(.white))
                                .cornerRadius(100)
                        }
                    }
                    if slot.beenRecorded == false{
                        Button(action: {
                            openSheet = true
                            print("toggled")
                        }) {
                            Image(systemName: "arrow.down.circle")
                                .font(.system(size: 40))
                                .background(Color(.white))
                                .cornerRadius(100)
                        }
                    }
                }
            }
            
            if canLink[numOfLinks] && (slot.beenRecorded == true || slot.preset != "") && slot.isLooping{
                Button(action: {
                    slot.isLinked[numOfLinks].toggle()
                }) {
                    Image(systemName: slot.isLinked[numOfLinks] ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundColor(.purple)
                        .font(.system(size: 40))
                        .background(Color(.white))
                        .cornerRadius(100)
                }
            }
            if (loopState == false && (slot.beenRecorded == true) || (loopState ==  false && slot.preset != "")) && !canRecord && !edit && canLink[numOfLinks] == false  && slot.isLooping == true{
                VStack(spacing:1){
                    HStack(spacing:1){
                        Button(action:{
                            loopWatch.stop()
                            slot.isLooping = false
                            UserDefaults.standard.set(false, forKey: "l\(slot.id)")
                            if slot.audioPlayer.isPlaying{
                                slot.audioPlayer.stopPlayback()
                            }
                            num = 0
                            itiration = 0
                            slot.loopArr = []
                            slot.isLooping = false
                            UserDefaults.standard.set(false, forKey: "l\(slot.id)")
                        }){
                            Image(systemName: "xmark.circle")
                                .foregroundColor(slot.isLooping ? .black : .gray)
                                .font(.system(size: 40))
                                .background(Color(.white))
                                .cornerRadius(100)
                                .disabled(slot.isLooping)
                            
                        }
                        Button(action:{
                            slot.isLooping = true
                            UserDefaults.standard.set(true, forKey: "l\(slot.id)")
                            slot.loopArr = [[Bool]]()
                            UserDefaults.standard.set([[Bool]](), forKey: "arr\(slot.id)")
                            oneIsLooping = true
                            slot.loopEdit = true
                        }){
                            Image(systemName: slot.isLooping ? "repeat.circle.fill" : "repeat.circle")
                                .foregroundColor(.green )
                                .font(.system(size: 40))
                                .background(Color(.white))
                                .cornerRadius(100)
                            
                        }
                    }
                    HStack(spacing:1){
                        Button(action:{
                            loopWatch.stop()
                            if slot.audioPlayer.isPlaying{
                                slot.audioPlayer.stopPlayback()
                            }
                            num = 0
                            itiration = 0
                        }){
                            Image(systemName: "stop.circle")
                                .foregroundColor(loopWatch.isRunning ? .black : .gray)
                                .font(.system(size: 40))
                                .background(Color(.white))
                                .cornerRadius(100)
                        }
                        Image(systemName: "play.circle")
                            .foregroundColor(slot.isLooping ? .black  : .gray)
                            .font(.system(size: 40))
                            .background(Color(.white))
                            .cornerRadius(100)
                            .gesture(LongPressGesture().onChanged { _ in
                                loopWatch.tempo = tempo
                                if !slot.isLooping {
                                    quickAudio()
                                    print(slot.isLooping)
                                }
                                if slot.isLooping{
                                    loopWatch.stop()
                                    loopWatch.start()
                                }
                            })
                            .disabled(!slot.isLooping)
                            .onChange(of: loopWatch.secondsElapsed) { _ in
                                if loopWatch.isRunning{
                                    if slot.loopArr[itiration][num] == true{
                                        quickAudio()
                                    }
                                    if num == 31{
                                        if (itiration + 1) == slot.loopArr.count{
                                            itiration = 0
                                        } else {
                                            itiration += 1
                                        }
                                        num = 0
                                    } else {
                                        num += 1
                                    }
                                    
                                }
                            }
                    }
                }
            }
            if loopState && ((slot.beenRecorded == true) || (slot.preset != "")){
            Button(action:{
                oneIsLooping = true
                slot.loopEdit = true
            }){
                Image(systemName: slot.isLooping ? "repeat.circle.fill" : "repeat.circle")
                    .foregroundColor(.green )
                    .font(.system(size: 50))
                    .background(Color(.white))
                    .cornerRadius(100)
                
            }
            }
        }
    }
}
