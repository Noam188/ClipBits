
import SwiftUI
let lineWidth: CGFloat = 30
let radius: CGFloat = 70
struct ContentView: Identifiable, View{
    @StateObject var audioRecorder = AudioRecorder()
    @State var canRecord = false /// this is for enabling/fbling universal recording ability
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
    @State var editLink = true
    @State var canLink = [false,false,false,false]
    @State var areLinking = [false,false,false,false]
    @State var tempo:Int
    func atLeastOne()->Bool{
        for index in slots.indices {
            if slots[index].isLinked[numOflinks]{
                return true
            }
        }
        return false
    }
    var id:String
    @ObservedObject var stopWatchManager = StopWatchManager()
    @ObservedObject var recTimer = RecTimer()
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
    init(id:String){
        self.id = id
        if UserDefaults.standard.integer(forKey: "tempo") == 0{
            self.tempo = 120
            UserDefaults.standard.set(120, forKey: "tempo")
        }
        self.tempo = UserDefaults.standard.integer(forKey: "tempo")
//        var emptyArr = [Slot]()
//        for i in 0...11{
//            emptyArr.append(Slot(id: "slot\(i)+\(id)"))
//        }
//        slots = emptyArr
        print(tempo)
        print(UserDefaults.standard.integer(forKey: "tempo"))
    }
    func checkAvailable()->Bool{
        for index in slots.indices {
            if slots[index].preset != "" || slots[index].beenRecorded == true && slots[index].isLooping{
                return true
            }
        }
        return false
    }
    func disable()->Bool{
        if !canRecord && !edit && !loopState{
            return false
        }
        return true
    }
    func findCurrentSlot()-> Int {
        for i in slots.indices{
            if slots[i].loopEdit == true{
                return i
            }
        }
        return 0
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

                ZStack{
                    VStack{
                        ZStack{
                            if canLink[numOflinks]{
                                Button(action: {
                                    canLink[numOflinks] = false
                                    if areLinking[numOflinks] == true && !atLeastOne(){
                                        areLinking[numOflinks] = false
                                    } else if atLeastOne(){
                                        areLinking[numOflinks] = true
                                    }
                                }){
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(.white)
                                            .cornerRadius(20)
                                            .shadow(radius: 3)
                                        if areLinking[numOflinks] == true && !atLeastOne(){
                                            Text("Delete")
                                                .foregroundColor(.red)
                                        } else if atLeastOne() || areLinking[numOflinks] == false{
                                            Text("Done")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }.frame(height: 75).padding(.horizontal)
                            }else{
                                BPM(tempo: $tempo).environmentObject(stopWatchManager).environmentObject(recTimer)
                                    .padding(.top,2)
                            }
                            
                        }
                        .environmentObject(stopWatchManager)
                        ButtonReduced(slots: $slots, canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, num: $num, loopState: $loopState, oneIsLooping: $oneIsLooping,numOflinks: $numOflinks,canLink:$canLink, tempo: $tempo).environmentObject(stopWatchManager)
                            .padding()
                    }
                    LoopingTab(oneIsLooping: $oneIsLooping, slot: $slots[findCurrentSlot()], metronome: $metronome).environmentObject(recTimer)
                        .opacity(oneIsLooping ? 1 : 0)
                        .scaleEffect(oneIsLooping ? 1 : 0.01)
                        .animation(.easeInOut)
                        .animation(.easeOut)
                        .padding(.horizontal)
                        .shadow(radius: 4)
                    
                }
            }.padding(.top,75)
                .padding(.bottom,15)
            Rectangle()
                .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2)
                .cornerRadius(25)
                .foregroundColor(.white)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .opacity(oneIsRecording ? 1 : 0)
                .scaleEffect(oneIsRecording ? 1 : 0.01)
                .animation(.easeInOut)
                .animation(.easeOut)
            TimerWatch(num: $num, slots: $slots, canRecord: $canRecord, metronome: $metronome, oneIsRecording: $oneIsRecording).environmentObject(stopWatchManager)
        }.background(LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)).ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(id: "preview")
    }
}
struct underButton:View{
    var num:Int
    @Binding var dependent:[Bool]
    @Binding var link:Bool
    @State var checkmark = false
    var body: some View{
        Button(action: {
            checkmark.toggle()
            link.toggle()
            for i in 0...3{
                dependent[i] = false
            }
            dependent[num] = true
        }){
            
            Image(systemName: checkmark ? "pencil.circle.fill" :  "pencil.circle")
                .font(.system(size: 30))
                .foregroundColor(.black)
            
        }
    }
}
