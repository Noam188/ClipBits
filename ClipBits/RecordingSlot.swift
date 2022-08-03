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
    @Binding var oneIsLooping: Bool
    @State var fade = false
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var loopWatch = LoopWatch()
    @State var openSheet = false
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
            print("balls")
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
                                .foregroundColor(.gray)
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
                            .foregroundColor(.gray)
                        if slot.preset != nil{
                            Image(slot.preset!).resizable()
                        }
                        if slot.beenRecorded == true{
                            Image(systemName: slot.isLooping ? "repeat" : "waveform")
                                .foregroundColor((slot.isLooping && loopState) ? .green : .black)
                                .font(.system(size: 60))
                        }
                    }
                    .gesture(LongPressGesture().onChanged { _ in
                        if !slot.isLooping{
                            quickAudio()
                            print(slot.isLooping)
                        }
                        if slot.isLooping{
                            loopWatch.stop()
                            loopWatch.start()
                        }
                    })
                    .onChange(of: loopWatch.secondsElapsed) { _ in
//                        quickAudio()
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
            if loopState == true && (slot.beenRecorded == true) || (loopState == true && slot.preset != nil) {
                HStack{
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
                            .font(.system(size: 30))
                            .foregroundColor(slot.isLooping ? .black : .gray)
                            .font(.system(size: 60))
                            .disabled(slot.isLooping)
                        
                    }
                Button(action:{
                    slot.isLooping = true
                   oneIsLooping = true
                    slot.loopEdit = true
                }){
                    Image(systemName: slot.isLooping ? "repeat.circle.fill" : "repeat.circle")
                        .font(.system(size: 30))
                        .foregroundColor(.green )
                        .font(.system(size: 60))
                    
                }
            
                Button(action:{
                    loopWatch.stop()
                    if audioPlayer.isPlaying{
                    audioPlayer.stopPlayback()
                    }
                    num = 0
                    itiration = 0
                }){
                    Image(systemName: "stop.circle")
                        .font(.system(size: 30))
                        .foregroundColor(loopWatch.isRunning ? .black : .gray)
                        .font(.system(size: 60))
                        .disabled(loopWatch.isRunning)
                    
                }
                }
            }
            if edit == true {
                HStack{
                    if slot.preset != nil || slot.beenRecorded == true{
                        Button(action: {
                            slot.preset = nil
                            slot.beenRecorded = false
                            UserDefaults.standard.set(false, forKey: slot.id)
                        }) {
                            Image(systemName: "trash.circle")
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                        }
                    }
                    if slot.beenRecorded == false{
                        Button(action: {
                            openSheet = true
                            print("toggled")
                        }) {
                            Image(systemName: "arrow.down.circle")
                                .font(.system(size: 30))
                        }
                    }
                }
            }
            //            }
        }
         if oneIsLooping {
             Rectangle()
                 .cornerRadius(20)
                 .foregroundColor(.white)

            ZStack{
                VStack{
                    HStack{
                        Button(action:{
                            oneIsLooping = false
                            slot.loopEdit = false
                                    if  selectedMeasure == "1 measure"{
                                        slot.loopArr.append(dict)
                                    } else if selectedMeasure == "2 measures"{
                                        slot.loopArr.append(dict)
                                        slot.loopArr.append(dict2)
                                    } else if selectedMeasure == "3 measures"{
                                        slot.loopArr.append(dict)
                                        slot.loopArr.append(dict2)
                                        slot.loopArr.append(dict3)
                                    } else if selectedMeasure == "4 measures"{
                                        slot.loopArr.append(dict)
                                        slot.loopArr.append(dict2)
                                        slot.loopArr.append(dict3)
                                        slot.loopArr.append(dict4)
                                    }
                            print(slot.loopArr)
                            print(slot.isLooping)
                        }){
                            Text("Done")
                                .foregroundColor(.blue)
                        }.padding(.leading)
                        Spacer()

                        Text("Edit in")

                        Picker("Notes", selection: $selected) {
                            ForEach(notes, id: \.self) {
                                Text($0)
                            }
                        }.pickerStyle(MenuPickerStyle())
                            .onReceive(selected.publisher.first()){ _ in
                                if selected == "1/1 notes"{
                                    dict = [false]
                                } else if selected == "1/2 notes"{
                                    dict = [false,false]
                                } else if selected == "1/4 notes"{
                                    dict = [false,false,false,false]
                                } else if selected == "1/8 notes"{
                                    dict = [false,false,false,false,false,false,false,false]
                                } else if selected == "1/16 notes"{
                                    dict = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
                                } else {
                                    dict = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
                                }
                            }
                        Spacer()
                        Text("Done")
                            .foregroundColor(.clear)
                            .padding(.trailing)
                    }
                    HStack{
                        Text("Across")
                        Picker("Measures", selection: $selectedMeasure) {
                            ForEach(measures, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onReceive(selectedMeasure.publisher.first()){ _ in
                            for i in 0...dict.count-1{
                                dict[i] = false
                            }
                            dict2 = dict
                            dict3 = dict
                            dict4 = dict
                        }
                    }


                    if selectedMeasure == "1 measure"{
                        OneMeasure(mode:selected,dict:$dict)
                    } else if selectedMeasure == "2 measures"{
                        OneMeasure(mode:selected,dict:$dict)
                        OneMeasure(mode:selected,dict:$dict2)
                    } else if selectedMeasure == "3 measures"{
                        OneMeasure(mode:selected,dict:$dict)
                        OneMeasure(mode:selected,dict:$dict2)
                        OneMeasure(mode:selected,dict:$dict3)
                    } else if selectedMeasure == "4 measures"{
                        OneMeasure(mode:selected,dict:$dict)
                        OneMeasure(mode:selected,dict:$dict2)
                        OneMeasure(mode:selected,dict:$dict3)
                        OneMeasure(mode:selected,dict:$dict4)
                    }
                }
            }.padding()
         }
        }
    }
}
