import SwiftUI
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
