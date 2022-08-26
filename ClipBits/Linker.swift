import AVKit
import SwiftUI

struct Linked: View{
    @State var isPlaying = false
    @Binding var slots:[Slot]
    @StateObject var audioPlayer = AudioPlayer()
    @State var audioPlayer2:AVAudioPlayer!
    @ObservedObject var loopWatch = LoopWatch()
    @State var num = [0,0,0,0,0,0,0,0,0,0,0,0]
    @State var itiration = [0,0,0,0,0,0,0,0,0,0,0,0]
    var numID:Int
    @State var slotCopies = [
        SlotCopy(id: "slot0"),
        SlotCopy(id: "slot1"),
        SlotCopy(id: "slot2"),
        SlotCopy(id: "slot3"),
        SlotCopy(id: "slot4"),
        SlotCopy(id: "slot5"),
        SlotCopy(id: "slot6"),
        SlotCopy(id: "slot7"),
        SlotCopy(id: "slot8"),
        SlotCopy(id: "slot9"),
        SlotCopy(id: "slot10"),
        SlotCopy(id: "slot11"),
    ]
    var body: some View {
        HStack{
            VStack{
                Button(action: {
                    isPlaying.toggle()
                    loopWatch.stop()
                    if isPlaying == true{
                    loopWatch.start()
                    }
                }){
                    Image(systemName: isPlaying ? "stop.circle" : "play.circle")
                        .font(.system(size: 55))
                        .foregroundColor(.black)
                        .background(Color(.white))
                        .cornerRadius(100)
                }.onChange(of: loopWatch.secondsElapsed) { _ in
                    if loopWatch.isRunning == true{
                        for index in 0...11{
                            if slots[index].isLinked[numID] && loopWatch.isRunning == true{
                                if loopWatch.secondsElapsed % (32/slots[index].loopArr[itiration[index]].count) == 0{
                                    if slots[index].loopArr[itiration[index]][num[index]] == true{
                                        if slots[index].preset != nil{
                                            let sound = Bundle.main.path(forResource: slots[index].preset, ofType: "mp3")
                                            self.audioPlayer2 = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                                            self.audioPlayer2.play()
                                        }
                                        if slots[index].beenRecorded == true{
                                            self.audioPlayer.startPlayback()
                                        }
                                    }
                                    if (itiration[index] + 1) == slots[index].loopArr.count{
                                        itiration[index] = 0
                                    } else {
                                        itiration[index] += 1
                                    }
                                    if (num[index] + 1) == slots[index].loopArr[itiration[index]].count{
                                        num[index] = 0
                                    } else {
                                        num[index] += 1
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
struct SlotCopy: Identifiable {
    var id:String
    @State var num = 0
    @State var itiration = 0
    init(id:String){
        self.id = id
    }
}
