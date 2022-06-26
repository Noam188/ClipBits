
import SwiftUI
let lineWidth: CGFloat = 30
let radius: CGFloat = 70
struct ContentView: View{
    @State var canRecord = false /// this is for enabling/disabling universal recording ability
    @State var oneIsRecording = false /// if one slot is recording
    @State var edit = false
    @State var num: CGFloat = 3
    @State var loopState = false
    @State var showSettings = false
    @State var metronome = false
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
    var body: some View{
        ZStack{
            VStack{
                ControlPannel(canRecord: $canRecord, loopState: $loopState, edit: $edit, num: $num, slots: $slots, oneIsRecording: $oneIsRecording, showSettings: $showSettings, metronome: $metronome)
                    .environmentObject(stopWatchManager)
                    .padding(.top,40)
                    BPM()
                .environmentObject(stopWatchManager)

                ButtonReduced(slots: $slots, canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, num: $num, loopState: $loopState).environmentObject(stopWatchManager)
                    .padding()
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
            TimerWatch(oneIsRecording: $oneIsRecording, num: $num, slots: $slots, canRecord: $canRecord, metronome: $metronome).environmentObject(stopWatchManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(id: nil)
    }
}
