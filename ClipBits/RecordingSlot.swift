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
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var loopWatch = LoopWatch()
    @State var openSheet = false
    // looping stuff
    @State var itiration = 0
    @State var num = 0
    @State var selected = "1/4 notes"
    @State private var selectedMeasure = "1 measure"
    let notes = ["1/1 notes","1/2 notes","1/4 notes","1/8 notes","1/16 notes","1/32 notes"]
    let measures = ["1 measure","2 measures","3 measures","4 measures"]
    @State var dict = [false,false,false,false]
    @State var dict2 = [false,false,false,false]
    @State var dict3 = [false,false,false,false]
    @State var dict4 = [false,false,false,false]
    var index: Int
    // functions
    func getValue(val: CGFloat) -> String {
        return String(format: "%.2f", val)
    }

    func quickAudio(){
        if slot.beenRecorded == true{
            if let recording = audioRecorder.recordings.first(where: { $0.fileURL.lastPathComponent == "\(index).m4a" }) {
                self.audioPlayer.createAudioPlayer(audio: recording.fileURL)
                print("yep")
            } else {
                print("No audio url was saved")
            }
            self.audioPlayer.startPlayback()
            
            if audioPlayer.isPlaying == false {
                print("audio is playing")
            }
        }
        if slot.preset != nil{
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
                                if slot.preset != nil{
                                    Image(slot.preset!).resizable()
                                }
                                if slot.beenRecorded == true{
                                    Image(systemName: "waveform")
                                        .foregroundColor((slot.isLooping && loopState) ? .green : .black)
                                        .font(.system(size: 60))
                                }
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
                                else if slot.beenRecorded == false && canRecord{
                                    Image(systemName: "mic.fill")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 60))
                                }
                            }
                        }
                    }.sheet(isPresented: $openSheet, content: {Presets(presetName: $slot.preset, openSheet: $openSheet)})
                    if slot.preset != nil || slot.beenRecorded == true{
                        ZStack{
                            Rectangle()
                                .cornerRadius(20)
                                .foregroundColor(.white)
                                .shadow(radius: 3)
                            if slot.preset != nil{
                                Image(slot.preset!).resizable()
                            }
                            if slot.beenRecorded == true{
                                Image(systemName: slot.isLooping ? "repeat" : "waveform")
                                    .foregroundColor((slot.isLooping && loopState) ? .green : .black)
                                    .font(.system(size: 60))
                            }
                        }.blur(radius: edit || loopState ? 4 : 0)
                            .animation(.easeInOut)
                            .animation(.easeOut)
                        .gesture(LongPressGesture().onChanged { _ in
                                if !slot.isLooping {
                                    quickAudio()
                                    print(slot.isLooping)
                                }
                                if slot.isLooping{
                                    loopWatch.stop()
                                    loopWatch.start()
                                }
                        })
                        .onChange(of: loopWatch.secondsElapsed) { _ in
                            if loopWatch.isRunning == true{
                                print(slot.loopArr)
                                print(loopWatch.secondsElapsed % (32/slot.loopArr[itiration].count))
                                if loopWatch.secondsElapsed % (32/slot.loopArr[itiration].count) == 0{
                                    if slot.loopArr[itiration][num] == true{
                                        quickAudio()
                                    }
                                    if (itiration + 1) == slot.loopArr.count{
                                        itiration = 0
                                    } else {
                                        itiration += 1
                                    }
                                    if (num + 1) == slot.loopArr[itiration].count{
                                        num = 0
                                    } else {
                                        num += 1
                                    }
                                }
                            }
                        }
                    }
                }
                if canLink[numOfLinks] && (slot.beenRecorded == true || slot.preset != nil){
                    Button(action: {
                        slot.isLinked[numOfLinks].toggle()
                    }) {
                        Image(systemName: slot.isLinked[numOfLinks] ? "checkmark.circle.fill" : "checkmark.circle")
                            .font(.system(size: 30))
                            .foregroundColor(.purple)
                    }
                }
                //            }
            }
            if edit == true {
                HStack(spacing:1){
                    if slot.preset != nil || slot.beenRecorded == true{
                        Button(action: {
                            slot.preset = nil
                            slot.beenRecorded = false
                            UserDefaults.standard.set(false, forKey: slot.id)
                        }) {
                            Image(systemName: "trash.circle")
                                .font(.system(size: 45))
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
                                .font(.system(size: 45))
                                .background(Color(.white))
                                .cornerRadius(100)
                        }
                    }
                }
            }
            if loopState == true && (slot.beenRecorded == true) || (loopState == true && slot.preset != nil) {
                VStack(spacing:1){
                    HStack(spacing:1){
                    Button(action:{
                        loopWatch.stop()
                        slot.isLooping = false
                        if audioPlayer.isPlaying{
                            audioPlayer.stopPlayback()
                        }
                        num = 0
                        itiration = 0
                        slot.loopArr = []
                        dict = [false,false,false,false]
                        dict2 = [false,false,false,false]
                        dict3 = [false,false,false,false]
                        dict4 = [false,false,false,false]
                    }){
                        Image(systemName: "xmark.circle")
                            .foregroundColor(slot.isLooping ? .black : .gray)
                            .font(.system(size: 45))
                            .background(Color(.white))
                            .cornerRadius(100)
                            .disabled(slot.isLooping)
                        
                    }
                    Button(action:{
                        slot.isLooping = true
                        oneIsLooping = true
                        slot.loopEdit = true
                    }){
                        Image(systemName: slot.isLooping ? "repeat.circle.fill" : "repeat.circle")
                            .foregroundColor(.green )
                            .font(.system(size: 45))
                            .background(Color(.white))
                            .cornerRadius(100)
                        
                    }
                }
                HStack(spacing:1){
                    Button(action:{
                        loopWatch.stop()
                        if audioPlayer.isPlaying{
                            audioPlayer.stopPlayback()
                        }
                        num = 0
                        itiration = 0
                    }){
                        Image(systemName: "stop.circle")
                            .foregroundColor(loopWatch.isRunning ? .black : .gray)
                            .font(.system(size: 45))
                            .background(Color(.white))
                            .cornerRadius(100)
                    }
                        Image(systemName: "play.circle")
                        .foregroundColor(slot.isLooping ? .black  : .gray)
                            .font(.system(size: 45))
                            .background(Color(.white))
                            .cornerRadius(100)
                            .gesture(LongPressGesture().onChanged { _ in
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
                                if loopWatch.isRunning == true{
                                    print(slot.loopArr)
                                    print(loopWatch.secondsElapsed % (32/slot.loopArr[itiration].count))
                                    if loopWatch.secondsElapsed % (32/slot.loopArr[itiration].count) == 0{
                                        if slot.loopArr[itiration][num] == true{
                                            quickAudio()
                                        }
                                        if (itiration + 1) == slot.loopArr.count{
                                            itiration = 0
                                        } else {
                                            itiration += 1
                                        }
                                        if (num + 1) == slot.loopArr[itiration].count{
                                            num = 0
                                        } else {
                                            num += 1
                                        }
                                    }
                                }
                            }
                    
                }
                }
            }

        }
    }
}
