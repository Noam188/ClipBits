
import SwiftUI

struct ContentView: View {
    @State var record = false
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    record.toggle()
                }) {
                    Image(systemName: "mic.circle")
                        .font(.system(size:45))
                        .foregroundColor(.black)
                }
                Text("Press the mic, then select the slot you'd like to record on")
                
            }
            HStack{
                ButtonSlot()
                ButtonSlot()
                ButtonSlot()
            }
            HStack{
                ButtonSlot()
                ButtonSlot()
                ButtonSlot()
                
            }
            HStack{
                ButtonSlot()
                ButtonSlot()
                ButtonSlot()
                
            }
            HStack{
                ButtonSlot()
                ButtonSlot()
                ButtonSlot()
                
            }
            
        }
        .padding()
        
    }
}
struct ButtonSlot: View {
    @State private var isRecording = false
    var contentView = ContentView()
    var body: some View{
        Button(action:{
            if contentView.record == true{
                isRecording.toggle()
            }
        }) {
            ZStack{
                Rectangle()
                    .cornerRadius(20)
                    .foregroundColor(.gray)
                if isRecording == true{
                    Image(systemName: "waveform.path")
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
