
import SwiftUI
let lineWidth: CGFloat = 30
let radius: CGFloat = 70
struct ContentView: View{
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
    @State var canLink1 = false
    @State var canLink2 = false
    @State var canLink3 = false
    @State var canLink4 = false
    func atLeastOne()->Bool{
        for index in slots.indices {
            if slots[index].isLinked1 || slots[index].isLinked2 || slots[index].isLinked3 || slots[index].isLinked4{
                return true
            }
        }
        return false
    }
    var id:String?
    @ObservedObject var stopWatchManager = StopWatchManager()
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
    func atLeastLink()->Bool{
        if canLink1 || canLink2 || canLink3 || canLink4{
            return true
        }
        return false
    }
    func turnOff(){
        canLink1 = false
        canLink2 = false
        canLink3 = false
        canLink4 = false
    }
    var body: some View{
        ZStack{
            VStack{
                ControlPannel(canRecord: $canRecord, loopState: $loopState, edit: $edit, num: $num, slots: $slots, oneIsRecording: $oneIsRecording, showSettings: $showSettings, metronome: $metronome)
                    .environmentObject(stopWatchManager)
                    .padding(.top,40)
                ZStack{
                    if atLeastOne(){
                        Button(action: {
                            turnOff()
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
                ButtonReduced(slots: $slots, canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, num: $num, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4).environmentObject(stopWatchManager)
                    .padding()
            Text("My backing tracks:")
                ZStack{
                Rectangle()
                        .foregroundColor(.gray)
                        .cornerRadius(20)
                        .frame(height: 75)
                        .padding(.horizontal)
                    HStack{
                        
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
