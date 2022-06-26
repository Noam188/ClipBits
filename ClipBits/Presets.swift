import SwiftUI

struct Presets: View{
    @Binding var presetName:String?
    @Binding var openSheet:Bool
    var body: some View {
        NavigationView{
        VStack{
            HStack{
                Button{
                    presetName = "Snare"
                    openSheet = false
                } label: {
                    VStack{
                        Rectangle()
                            .cornerRadius(30)
                        Text("Snare")
                    }
                }.padding()
                Button{
                    presetName = "Kick"
                    openSheet = false
                } label: {
                    VStack{
                        Rectangle()
                            .cornerRadius(30)
                        Text("Bass Drum")
                    }
                }.padding()
            }
            HStack{
                Button{
                    presetName = "Hi-Hat"
                    openSheet = false
                } label: {
                    VStack{
                        Rectangle()
                            .cornerRadius(30)
                        Text("Hi Hat")
                    }
                }.padding()
                Button{
                    presetName = "Open-Hi"
                    openSheet = false
                } label: {
                    VStack{
                        Rectangle()
                            .cornerRadius(30)
                        Text("Open Hi Hat")
                    }
                }.padding()
            }
        }.padding()
        }
    }
}
