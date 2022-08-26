import SwiftUI
import AVKit
struct LoopingTab:View{
    @Binding var oneIsLooping:Bool
    @Binding var slot:Slot
    @StateObject var audioPlayer = AudioPlayer()
    @StateObject var audioRecorder = AudioRecorder()
    @State var audioPlayer2:AVAudioPlayer!
    @State var itiration = 0
    @State var num = 0
    @State var selected = "1/4 notes"
    @State var inputselect = "Manually input"
    @State private var selectedMeasure = "1 measure"
    let input = ["Manually input","Record"]
    let notes = ["1/1 notes","1/2 notes","1/4 notes","1/8 notes","1/16 notes","1/32 notes"]
    let measures = ["1 measure","2 measures","3 measures","4 measures"]
    @State var dict = [false,false,false,false]
    @State var dict2 = [false,false,false,false]
    @State var dict3 = [false,false,false,false]
    @State var dict4 = [false,false,false,false]
    @State var loopArr = [[Bool]]()
    @State var count1 = false
    @ObservedObject var recTimer = RecTimer()
    var body: some View{
        Rectangle()
            .cornerRadius(20)
            .foregroundColor(.white)
        
        ZStack{
            VStack{
                Picker("Notes", selection: $inputselect) {
                    ForEach(input, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .onReceive(inputselect.publisher.first()){ _ in
                        if inputselect == "Manually input"{
                            dict = [false,false,false,false]
                            dict2 = [false,false,false,false]
                            dict3 = [false,false,false,false]
                            dict4 = [false,false,false,false]
                        } else {
                            dict = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
                            dict2 = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
                            dict3 = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
                            dict4 = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
                        }
                    }
                HStack{
                    Button(action:{
                        oneIsLooping = false
                        slot.loopEdit = false
                        if  inputselect == "Manually input"{
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
                        } else {
                            slot.loopArr = loopArr
                        }
                        self.dict = [false,false,false,false]
                        self.dict2 = [false,false,false,false]
                        self.dict2 = [false,false,false,false]
                        self.dict3 = [false,false,false,false]
                        print(slot.loopArr)
                        print(slot.isLooping)
                    }){
                        Text("Done")
                            .foregroundColor(.blue)
                    }.padding(.leading)
                    Spacer()
                    if inputselect == "Manually input"{
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
                    }
                    Spacer()
                    if inputselect == "Manually input"{
                        Text("Done")
                            .foregroundColor(.clear)
                            .padding(.trailing)
                    } else{
                        Toggle("Record the \n initial hit",isOn: $count1)
                                .padding(.horizontal,20)
//                                Text("\(recTimer.displaySeconds)")
//                                    .foregroundColor(.red)
//                                    .padding(.trailing)
                    }
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
                
                if inputselect == "Manually input"{
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
                } else {
                    ZStack{
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                        if slot.preset != nil{
                            Image(slot.preset!).resizable()
                        } else {
                            Image(systemName: "waveform")
                                .foregroundColor(.black )
                                .font(.system(size: 100))
                        }
                    }.gesture(LongPressGesture().onChanged { _ in
                        if slot.preset != nil{
                            let sound = Bundle.main.path(forResource: slot.preset, ofType: "mp3")
                            self.audioPlayer2 = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                            self.audioPlayer2.play()
                        }
                        if slot.beenRecorded == true{
                            self.audioPlayer.startPlayback()
                        }
                        print("pressed")
                        if recTimer.isRunning == false{
                            if selectedMeasure == "1 measure"{
                                loopArr = [[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]]
                            } else if selectedMeasure == "2 measures"{
                                loopArr = [[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]]
                            } else if selectedMeasure == "3 measures"{
                                loopArr = [[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]]
                            } else if selectedMeasure == "4 measures"{
                                loopArr = [[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]]
                            }
                            recTimer.start()
                        }
                        loopArr[itiration][num] = true
                        print("\(itiration) + \(num)")
                        print(loopArr[itiration][num])
                        
                    })
                        .onChange(of: recTimer.secondsElapsed) { _ in
                            print(num)
                            print(itiration)
                            if recTimer.secondsElapsed % 32 == 0 && recTimer.secondsElapsed > 0          {
                                if (itiration + 1) == loopArr.count{
                                    recTimer.stop()
                                    print(loopArr)
                                } else {
                                    itiration += 1
                                }
                            }
                                if (num + 1) == loopArr[itiration].count{
                                    num = 0
                                } else {
                                    num += 1
                                }
//                            }
                        }
                    
                }
            }
        }.padding()
    }
}
struct OneMeasure: View{
    var mode:String
    @Binding var dict:[Bool]
    var body: some View {
        if mode == "1/1 notes"{
            ButtonSec(dict: $dict, num: 1)
        }
        if mode == "1/2 notes"{
            HStack{
                ButtonSec(dict: $dict, num: 1)
                ButtonSec(dict: $dict, num: 2)
            }
        }
        if mode == "1/4 notes"{
            HStack{
                ButtonSec(dict: $dict, num: 1)
                ButtonSec(dict: $dict, num: 2)
                ButtonSec(dict: $dict, num: 3)
                ButtonSec(dict: $dict, num: 4)
            }
        }
        if mode == "1/8 notes"{
            HStack{
                ButtonSec(dict: $dict, num: 1)
                ButtonSec(dict: $dict, num: 2)
                ButtonSec(dict: $dict, num: 3)
                ButtonSec(dict: $dict, num: 4)
                ButtonSec(dict: $dict, num: 5)
                ButtonSec(dict: $dict, num: 6)
                ButtonSec(dict: $dict, num: 7)
                ButtonSec(dict: $dict, num: 8)
            }
        }
        if mode == "1/16 notes"{
            VStack{
                HStack{
                    ButtonSec(dict: $dict, num: 1)
                    ButtonSec(dict: $dict, num: 2)
                    ButtonSec(dict: $dict, num: 3)
                    ButtonSec(dict: $dict, num: 4)
                    ButtonSec(dict: $dict, num: 5)
                    ButtonSec(dict: $dict, num: 6)
                    ButtonSec(dict: $dict, num: 7)
                    ButtonSec(dict: $dict, num: 8)
                }
                HStack{
                    ButtonSec(dict: $dict, num: 9)
                    ButtonSec(dict: $dict, num: 10)
                    ButtonSec(dict: $dict, num: 11)
                    ButtonSec(dict: $dict, num: 12)
                    ButtonSec(dict: $dict, num: 13)
                    ButtonSec(dict: $dict, num: 14)
                    ButtonSec(dict: $dict, num: 15)
                    ButtonSec(dict: $dict, num: 16)
                }
                
            }
        }
        if mode == "1/32 notes"{
            VStack{
                HStack{
                    ButtonSec(dict: $dict, num: 1)
                    ButtonSec(dict: $dict, num: 2)
                    ButtonSec(dict: $dict, num: 3)
                    ButtonSec(dict: $dict, num: 4)
                    ButtonSec(dict: $dict, num: 5)
                    ButtonSec(dict: $dict, num: 6)
                    ButtonSec(dict: $dict, num: 7)
                    ButtonSec(dict: $dict, num: 8)
                }
                HStack{
                    ButtonSec(dict: $dict, num: 9)
                    ButtonSec(dict: $dict, num: 10)
                    ButtonSec(dict: $dict, num: 11)
                    ButtonSec(dict: $dict, num: 12)
                    ButtonSec(dict: $dict, num: 13)
                    ButtonSec(dict: $dict, num: 14)
                    ButtonSec(dict: $dict, num: 15)
                    ButtonSec(dict: $dict, num: 16)
                }
                HStack{
                    ButtonSec(dict: $dict, num: 17)
                    ButtonSec(dict: $dict, num: 18)
                    ButtonSec(dict: $dict, num: 19)
                    ButtonSec(dict: $dict, num: 20)
                    ButtonSec(dict: $dict, num: 21)
                    ButtonSec(dict: $dict, num: 22)
                    ButtonSec(dict: $dict, num: 23)
                    ButtonSec(dict: $dict, num: 24)
                }
                HStack{
                    ButtonSec(dict: $dict, num: 25)
                    ButtonSec(dict: $dict, num: 26)
                    ButtonSec(dict: $dict, num: 27)
                    ButtonSec(dict: $dict, num: 28)
                    ButtonSec(dict: $dict, num: 29)
                    ButtonSec(dict: $dict, num: 30)
                    ButtonSec(dict: $dict, num: 31)
                    ButtonSec(dict: $dict, num: 32)
                }
            }
        }
    }
}

struct ButtonSec:View{
    @Binding var dict:[Bool]
    var num:Int
    @State var colorBut = false
    var body: some View{
        Button(action:{
            dict[num-1].toggle()
            colorBut.toggle()
            print(dict)
        }){
            Rectangle()
                .cornerRadius(2)
                .shadow(radius: 3)
                .foregroundColor(colorBut ? .blue : .white)
        }
    }
}
