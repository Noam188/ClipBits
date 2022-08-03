import AVKit
import SwiftUI

struct Quantizer: View{
    @State var dict = ["None","1/1 notes","1/2 notes","1/4 notes","1/8 notes","1/16 notes","1/32 notes"]
    @State private var selected = "1/4 notes"
    @Binding var shallRecord:Bool
    var body: some View {
        VStack{
        Text("Quantizing:")
            HStack{
        Picker("Notes", selection: $selected) {
            ForEach(dict, id: \.self) {
                Text($0)
            }
        }.pickerStyle(.segmented)
                Button(action:{
                    shallRecord = true
                }){
                    Text("Done")
                        .foregroundColor(.blue)
                }.padding(.leading)
            }
        }
    }
}
