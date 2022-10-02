import SwiftUI

struct Presets: View{
    @Binding var presetName:String
    @Binding var openSheet:Bool
    var body: some View {
        NavigationView{
            ScrollView{
                ZStack{
                VStack{
                    HStack{
                        Preset(name: "Snare", text: "Snare", presetName: $presetName, openSheet: $openSheet)
                        Spacer()
                        Preset(name: "Kick", text: "Kick drum", presetName: $presetName, openSheet: $openSheet)
                    }.padding(.horizontal,15)
                    HStack{
                        Preset(name: "Hi-Hat", text: "Hi-hat", presetName: $presetName, openSheet: $openSheet)
                        Spacer()
                        Preset(name: "Open-Hi", text: "Open Hi-hat", presetName: $presetName, openSheet: $openSheet)
                    }.padding(.horizontal,15)
                }.padding(.top)
                }
            }.background(LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)).ignoresSafeArea()
        }
    }
}
struct Preset:View{
    var name:String
    var text:String
    @Binding var presetName:String
    @Binding var openSheet:Bool
    var body: some View{
        Button{
            presetName = name
            openSheet = false
        } label: {
            VStack(spacing:10){
                ZStack{
                Rectangle()
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .shadow( radius: 6)
                    Image(name).resizable()
                }.frame(width: UIScreen.main.bounds.size.width / 2.2, height: UIScreen.main.bounds.size.width / 2.2)
                Text(text)
                    .foregroundColor(.black)
            }.padding(1)
        }
    }
}
