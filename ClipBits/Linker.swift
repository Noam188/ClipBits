//import AVKit
//import SwiftUI
//
//struct Linked: View{
//    @State var isPlaying = false
//    @Binding var slots:[Slot]
//    @StateObject var audioPlayer = AudioPlayer()
//    @State var audioPlayer2:AVAudioPlayer!
//    @ObservedObject var loopWatch = LoopWatch()
//    @State var num = 0
//    @State var itiration = [0,0,0,0,0,0,0,0,0,0,0,0,0]
//    @State var tester = 0
//    var numID:Int
//    var body: some View {
//        HStack{
//            VStack{
//                Button(action: {
//                    isPlaying.toggle()
//                    loopWatch.stop()
//                    if isPlaying == true{
//                    loopWatch.start()
//                    }
//                }){
//                    Image(systemName: isPlaying ? "stop.circle" : "play.circle")
//                        .font(.system(size: 55))
//                        .foregroundColor(.black)
//                        .background(Color(.white))
//                        .cornerRadius(100)
//                }.onChange(of: loopWatch.secondsElapsed) { _ in
//                        for index in 0...11{
//                            if slots[index].isLinked[numID]{
//                                if slots[index].loopArr[itiration[index]][num] == true{
//                                    if slots[index].preset != ""{
//                                        let sound = Bundle.main.path(forResource: slots[index].preset, ofType: "mp3")
//                                        self.audioPlayer2 = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
//                                        self.audioPlayer2.play()
//                                    }
//                                    if slots[index].beenRecorded == true{
//                                        self.audioPlayer.startPlayback()
//                                    }
//                                }
//                                if (num + 1) == 32{
//                                    if (itiration[index] + 1) == slots[index].loopArr.count{
//                                        itiration[index] = 0
//                                    } else {
//                                        itiration[index] += 1
//                                    }
//                                }
//                            }
//                        }
//                        if (num + 1) == 32{
//                            num = 0
//                        } else {
//                            num += 1
//                        }
//                }
//            }
//        }
//    }
//}
//struct SlotCopy: Identifiable {
//    var id:String
//    @State var num = 0
//    @State var itiration = 0
//    init(id:String){
//        self.id = id
//    }
//}
