
import SwiftUI

/// put each slot's state in a reusable struct, makes things more organized
/// plus you can also add other properties that are independent to each slot
let lineWidth: CGFloat = 30
let radius: CGFloat = 70

struct Slot: Identifiable {
    var id: String
    var isChecked = false
    var isRecording = false
    var beenRecorded: Bool?
    var isTrimming = false
    
    init(id: String) {
        self.id = id
        isChecked = false
        isRecording = false
        isTrimming = false
        beenRecorded = UserDefaults.standard.bool(forKey: id)
    }
}

class StopWatchManager: ObservableObject {
    @Published var secondsElapsed = 1
    @Published var mode: StopWatchMode = .stopped
    
    
    @Published var timer = Timer()
    enum StopWatchMode {
        case running
        case stopped
        case paused
    }
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: (60 / 120), repeats: true) { _ in
            if self.secondsElapsed != 4{
                self.secondsElapsed = self.secondsElapsed + 1
            }
            else{
                self.secondsElapsed = 1
            }
        }
    }
    
    func stop() {
        timer.invalidate()
        secondsElapsed = 1
        mode = .stopped
    }
}

struct ContentView: View {
    @StateObject var audioRecorder = AudioRecorder()
    @State var canRecord = false /// this is for enabling/disabling universal recording ability
    @State var oneIsRecording = false /// if one slot is recording
    @State var oneIsTrimming = false
    @State var edit = false
    @State var trim = false
    @State var anim = false
    @State var ten = false
    @State var num: CGFloat = 4
    @State var isActive = false
    @State var timeRemaining: CGFloat = 3
    @State var loopState = false
    @State var bpm = 120
    @State var measuresRecorded = 0
    @State var measuresNeeded = 1
    @ObservedObject var stopWatchManager = StopWatchManager()
    let timer = Timer.publish(every: (60 / 120), on: .main, in: .common).autoconnect()
    @State var slots = [
        Slot(id: "slot0"),
        Slot(id: "slot1"),
        Slot(id: "slot2"),
        Slot(id: "slot3"),
        Slot(id: "slot4"),
        Slot(id: "slot5"),
        Slot(id: "slot6"),
        Slot(id: "slot7"),
        Slot(id: "slot8"),
        Slot(id: "slot9"),
        Slot(id: "slot10"),
        Slot(id: "slot11"),
    ]
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
    }
    
    func hasAtLeastOneChecked() -> Bool {
        var numberOfChecked = 0
        for slot in slots {
            if slot.isChecked {
                numberOfChecked += 1
            }
        }
        if numberOfChecked > 0 {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        if edit == false, canRecord == false {
                            loopState.toggle()
                        }
                    }) {
                        Image(systemName: loopState ? "repeat.circle.fill" : "repeat.circle")
                            .font(.system(size: 45))
                            .foregroundColor(loopState ? .green : .black)
                    }
                    Button(action: {
                        if canRecord == false, loopState == false {
                            if hasAtLeastOneChecked() {
                                for index in slots.indices {
                                    if slots[index].isChecked {
                                        slots[index].beenRecorded = false
                                        UserDefaults.standard.set(false, forKey: slots[index].id)
                                    }
                                    slots[index].isChecked = false
                                }
                                edit.toggle()
                            } else {
                                edit.toggle()
                            }
                        }
                    }) {
                        if hasAtLeastOneChecked() && edit {
                            Image(systemName: "trash.circle.fill")
                                .font(.system(size: 45))
                                .foregroundColor(.red)
                        } else {
                            Image(systemName: edit ? "pencil.circle.fill" : "pencil.circle")
                                .font(.system(size: 45))
                                .foregroundColor(edit ? .blue : .black)
                        }
                    }
                    
                    Button(action: {
                        if loopState == false, edit == false {
                            canRecord.toggle()
                            for index in slots.indices {
                                if slots[index].isRecording {
                                    slots[index].isRecording = false
                                    self.audioRecorder.stopRecording()
                                }
                            }
                            oneIsRecording = false
                            timeRemaining = num
                        }
                    }) {
                        Image(systemName: canRecord ? "mic.circle.fill" : "mic.circle")
                            .font(.system(size: 45))
                            .foregroundColor(canRecord ? .red : .black)
                    }
                    Button(action: {
                        if num == 4 {
                            num = 8
                        } else {
                            num = 4
                        }
                        timeRemaining = num
                    }) {
                        Text("\(Int(num))")
                            .font(.system(size: 30))
                            .padding(14)
                            .foregroundColor(.black)
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.black, lineWidth: 4)
                            )
                    }
                }
                Spacer()
                HStack {
                    ButtonSlot(slot: $slots[0], canRecord: $canRecord, oneIsRecording: $oneIsRecording, oneIsTrimming: $oneIsTrimming, edit: $edit, trim: $trim, anim: $trim, isActive: $isActive, loopState: $loopState, audioRecorder: audioRecorder, index: 0)
                    ButtonSlot(slot: $slots[1], canRecord: $canRecord, oneIsRecording: $oneIsRecording, oneIsTrimming: $oneIsTrimming, edit: $edit, trim: $trim, anim: $trim, isActive: $isActive, loopState: $loopState, audioRecorder: audioRecorder, index: 1)
                    ButtonSlot(slot: $slots[2], canRecord: $canRecord, oneIsRecording: $oneIsRecording, oneIsTrimming: $oneIsTrimming, edit: $edit, trim: $trim, anim: $trim, isActive: $isActive, loopState: $loopState, audioRecorder: audioRecorder, index: 2)
                }
                HStack {
                    ButtonSlot(slot: $slots[3], canRecord: $canRecord, oneIsRecording: $oneIsRecording, oneIsTrimming: $oneIsTrimming, edit: $edit, trim: $trim, anim: $trim, isActive: $isActive, loopState: $loopState, audioRecorder: audioRecorder, index: 3)
                    ButtonSlot(slot: $slots[4], canRecord: $canRecord, oneIsRecording: $oneIsRecording, oneIsTrimming: $oneIsTrimming, edit: $edit, trim: $trim, anim: $trim, isActive: $isActive, loopState: $loopState, audioRecorder: audioRecorder, index: 4)
                    ButtonSlot(slot: $slots[5], canRecord: $canRecord, oneIsRecording: $oneIsRecording, oneIsTrimming: $oneIsTrimming, edit: $edit, trim: $trim, anim: $trim, isActive: $isActive, loopState: $loopState, audioRecorder: audioRecorder, index: 5)
                }
                HStack {
                    ButtonSlot(slot: $slots[6], canRecord: $canRecord, oneIsRecording: $oneIsRecording, oneIsTrimming: $oneIsTrimming, edit: $edit, trim: $trim, anim: $trim, isActive: $isActive, loopState: $loopState, audioRecorder: audioRecorder, index: 6)
                    ButtonSlot(slot: $slots[7], canRecord: $canRecord, oneIsRecording: $oneIsRecording, oneIsTrimming: $oneIsTrimming, edit: $edit, trim: $trim, anim: $trim, isActive: $isActive, loopState: $loopState, audioRecorder: audioRecorder, index: 7)
                    ButtonSlot(slot: $slots[8], canRecord: $canRecord, oneIsRecording: $oneIsRecording, oneIsTrimming: $oneIsTrimming, edit: $edit, trim: $trim, anim: $trim, isActive: $isActive, loopState: $loopState, audioRecorder: audioRecorder, index: 8)
                }
                HStack {
                    ButtonSlot(slot: $slots[9], canRecord: $canRecord, oneIsRecording: $oneIsRecording, oneIsTrimming: $oneIsTrimming, edit: $edit, trim: $trim, anim: $trim, isActive: $isActive, loopState: $loopState, audioRecorder: audioRecorder, index: 9)
                    ButtonSlot(slot: $slots[10], canRecord: $canRecord, oneIsRecording: $oneIsRecording, oneIsTrimming: $oneIsTrimming, edit: $edit, trim: $trim, anim: $trim, isActive: $isActive, loopState: $loopState, audioRecorder: audioRecorder, index: 10)
                    ButtonSlot(slot: $slots[11], canRecord: $canRecord, oneIsRecording: $oneIsRecording, oneIsTrimming: $oneIsTrimming, edit: $edit, trim: $trim, anim: $trim, isActive: $isActive, loopState: $loopState, audioRecorder: audioRecorder, index: 11)
                }
            }
            .padding()
            
            Rectangle()
                .frame(width: 200, height: 200)
                .cornerRadius(25)
                .foregroundColor(.white)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .opacity(oneIsRecording ? 1 : 0)
                .scaleEffect(oneIsRecording ? 1 : 0)
                .animation(.easeInOut)
                .animation(.easeOut)
            VStack {
                Rectangle()
                    .frame(width: 200, height: 140)
                    .foregroundColor(.clear)
                    .overlay(
                        Text(String(stopWatchManager.secondsElapsed))
                            .font(.system(size: 60))
                            .fontWeight(.semibold)
                    ).onChange(of: stopWatchManager.secondsElapsed, perform:{ _ in
                        if stopWatchManager.secondsElapsed == 1 && measuresRecorded == 0{
                            for index in slots.indices {
                                if slots[index].isRecording {
                                    self.audioRecorder.startRecording(recordingName: "\(index)")
                                    print("yo")
                                }
                            }
                        }
                        if stopWatchManager.secondsElapsed == 1{
                            measuresRecorded += 1
                            if measuresNeeded == measuresRecorded{
                                canRecord.toggle()
                                self.stopWatchManager.stop()
                                for index in slots.indices {
                                    if slots[index].isRecording {
                                        slots[index].isRecording = false
                                        self.audioRecorder.stopRecording()
                                        print("balon")
                                    }
                                }
                                oneIsRecording = false
                            }
                        }
                    })
                
                Button(action: {
                    canRecord.toggle()
                    self.stopWatchManager.stop()
                    for index in slots.indices {
                        if slots[index].isRecording{
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
            }
            .opacity((oneIsRecording && !isActive) ? 1 : 0)
            Group {
                Circle()
                    .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .frame(width: radius * 2, height: radius * 2)
                    .opacity(oneIsRecording ? 1 : 0)
                    .scaleEffect(oneIsRecording ? 1 : 0)
                    .animation(.easeInOut)
                    .animation(.easeOut)
                
                Circle()
                    .trim(from: 0, to: 1 - (num - timeRemaining) / num)
                
                    .stroke((timeRemaining > (num / 3 + num / 3)) ?
                            Color.green :
                                (timeRemaining > (num / 3)) ?
                            Color.yellow : Color.red,
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut)
                    .frame(width: radius * 2, height: radius * 2)
                VStack {
                    Text("\(Int(timeRemaining))")
                        .font(.largeTitle)
                }.onReceive(timer, perform: { _ in
                    guard isActive else { return }
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        isActive = false
                        self.stopWatchManager.start()
//                        for index in slots.indices {
//                            if slots[index].isRecording {
//                                self.audioRecorder.startRecording(recordingName: "\(index)")
//                            }
//                        }
                    }
                })
            }
            .opacity((oneIsRecording && isActive) ? 1 : 0)
            .scaleEffect((oneIsRecording && isActive) ? 1 : 0)
            .animation(.easeInOut)
            .animation(.easeOut)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
