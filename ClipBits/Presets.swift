import SwiftUI

struct Presets: View{
    @Binding var presetName:String?
    @Binding var openSheet:Bool
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing:10){
                    HStack(spacing:10){
                        Preset(name: "Snare", text: "Snare", presetName: $presetName, openSheet: $openSheet)
                        Preset(name: "Kick", text: "Kick drum", presetName: $presetName, openSheet: $openSheet)
                    }.padding(.horizontal,20)
                    HStack(spacing:10){
                        Preset(name: "Hi-Hat", text: "Hi-hat", presetName: $presetName, openSheet: $openSheet)
                        Preset(name: "Open-Hi", text: "Open Hi-hat", presetName: $presetName, openSheet: $openSheet)
                    }.padding(.horizontal,20)
                }
            }
        }
    }
}
struct Preset:View{
    var name:String
    var text:String
    @Binding var presetName:String?
    @Binding var openSheet:Bool
    var body: some View{
        Button{
            presetName = name
            openSheet = false
        } label: {
            VStack(spacing:10){
                Rectangle()
                    .overlay(Image(name).resizable())
                    .cornerRadius(20)
                    .foregroundColor(.gray)
                Text(text)
            }
        }
    }
}
