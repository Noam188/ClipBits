
import SwiftUI
let lineWidth: CGFloat = 30
let radius: CGFloat = 70
struct ContentView: View{
    @StateObject var audioRecorder = AudioRecorder()
    @State var canRecord = false /// this is for enabling/disabling universal recording ability
    @State var oneIsRecording = false /// if one slot is recording
    @State var edit = false
    @State var num:CGFloat = 3
    @State var loopState = false
    @State var showSettings = false
    @State var metronome = false
    @State var oneIsLooping = false
    @State var shallRecord = false
    @State var showQuant = false
    @State var numOflinks = 0
    @State var canLink = [false,false,false,false]
    @State var areLinking = [false,false,false,false]
    func atLeastOne()->Bool{
        for index in slots.indices {
            if slots[index].isLinked[numOflinks]{
                return true
            }
        }
        return false
    }
    var id:String?
    @ObservedObject var stopWatchManager = StopWatchManager()
    @ObservedObject var looper = LoopWatch()
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
    init(id:String?){
        self.id = id
    }
    func show()->Bool{
        for i in areLinking{
            if i == false{
                return true
            }
        }
        return false
    }
    func newBack(){
        var num = 0
        for i in 0...3{
            var taken = false
            for index in slots.indices {
            if slots[index].isLinked[i] {
                    taken = true
                }
            }
            if taken{
            num += 1
            } else {
                numOflinks = num
                return
            }
        }
        numOflinks = num
    }
    var body: some View{
        ZStack{
            VStack{

                ControlPannel(canRecord: $canRecord, loopState: $loopState, edit: $edit, num: $num, slots: $slots, oneIsRecording: $oneIsRecording, showSettings: $showSettings, metronome: $metronome)
                    .environmentObject(stopWatchManager)
                    .padding(.top,40)
                ZStack{
                    if atLeastOne() && canLink[numOflinks]{
                        Button(action: {
                            areLinking[numOflinks] = true
                            canLink[numOflinks] = false
                        }){
                            ZStack{
                            Rectangle()
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                    .shadow(radius: 3)
                                Text("Done")
                                .foregroundColor(.blue)
                                
                            }
                        }.frame(height: 75).padding(.horizontal)
                    }else{
                    BPM().environmentObject(stopWatchManager)
                    }
                    
                }
                .environmentObject(stopWatchManager)
                ButtonReduced(slots: $slots, canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, num: $num, loopState: $loopState, oneIsLooping: $oneIsLooping,numOflinks: $numOflinks,canLink:$canLink).environmentObject(stopWatchManager)
                    .padding()
            Text("My backing tracks:")
                ZStack{
                Rectangle()
                        .foregroundColor(.gray)
                        .cornerRadius(20)
                        .padding(.horizontal)
                    HStack{
                        if areLinking[0]{
                            Linked(slots: $slots, numID: 0)
                        }
                        if areLinking[1]{
                            Linked(slots: $slots, numID: 1)
                        }
                        if areLinking[2]{
                            Linked(slots: $slots, numID: 2)
                        }
                        if areLinking[3]{
                            Linked(slots: $slots, numID: 3)
                        }
                        if show(){
                        Button(action: {
                            newBack()
                            canLink[numOflinks] = true
                            }){
                                VStack{
                            Image(systemName: "plus.circle")
                              .font(.system(size: 55))
                              .foregroundColor(.black)
                              .background(Color(.white))
                              .cornerRadius(100)
                            Image(systemName: "checkmark.circle")
                                }
                            }
                        }
                    }
                }
                }
            Rectangle()
                .frame(width: 200, height: 200)
                .cornerRadius(25)
                .foregroundColor(.white)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .opacity(oneIsRecording ? 1 : 0)
                .scaleEffect(oneIsRecording ? 1 : 0.01)
                .animation(.easeInOut)
                .animation(.easeOut)
            TimerWatch(num: $num, slots: $slots, canRecord: $canRecord, metronome: $metronome, oneIsRecording: $oneIsRecording).environmentObject(stopWatchManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(id: nil)
    }
}
