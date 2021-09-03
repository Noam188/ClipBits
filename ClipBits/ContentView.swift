
import SwiftUI

struct Slot {
    var isRecording = false
}
struct ContentView: View {
    @State var canRecord = false /// this is for enabling/disabling universal recording ability
    
    /// each of these has it's own individual `isRecording` state
    @State var slots = [
        Slot(),
        Slot(),
        Slot(),
        Slot(),
        Slot(),
        Slot(),
        Slot(),
        Slot(),
        Slot(),
        Slot(),
        Slot(),
        Slot()
    ]
    
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    canRecord.toggle()
                }) {
                    Image(systemName: "mic.circle")
                        .font(.system(size:45))
                        .foregroundColor(canRecord ? .red : .black)
                }
                Text("Press the mic, then select the slot you'd like to record on")
                
            }
            HStack{
                ButtonSlot(slot: $slots[0], canRecord: $canRecord)
                ButtonSlot(slot: $slots[1], canRecord: $canRecord)
                ButtonSlot(slot: $slots[2], canRecord: $canRecord)
            }
            HStack{
                ButtonSlot(slot: $slots[3], canRecord: $canRecord)
                ButtonSlot(slot: $slots[4], canRecord: $canRecord)
                ButtonSlot(slot: $slots[5], canRecord: $canRecord)
                
            }
            HStack{
                ButtonSlot(slot: $slots[6], canRecord: $canRecord)
                ButtonSlot(slot: $slots[7], canRecord: $canRecord)
                ButtonSlot(slot: $slots[8], canRecord: $canRecord)
                
            }
            HStack{
                ButtonSlot(slot: $slots[9], canRecord: $canRecord)
                ButtonSlot(slot: $slots[10], canRecord: $canRecord)
                ButtonSlot(slot: $slots[11], canRecord: $canRecord)
                
            }
            
        }
        .padding()
        
    }
}
struct ButtonSlot: View {
    @Binding var slot: Slot
    @Binding var canRecord: Bool
    
    //    var contentView = ContentView() /// this is wrong!
    
    var body: some View{
        Button(action:{
            if canRecord {
                slot.isRecording.toggle()
            }
        }) {
            ZStack{
                Rectangle()
                    .cornerRadius(20)
                    .foregroundColor(canRecord ? .green : .gray)
                    .animation(
                        canRecord
                            ? Animation.default.repeatForever(autoreverses: true)
                            : .default, /// stop animation if `canRecord` is false
                        value: canRecord
                    )
                
                if slot.isRecording {
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
