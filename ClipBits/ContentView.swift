
import SwiftUI

/// put each slot's state in a reusable struct, makes things more organized
/// plus you can also add other properties that are independent to each slot
struct Slot {
    var isRecording = false
}

struct ContentView: View {
    @State var canRecord = false /// this is for enabling/disabling universal recording ability
    @State var oneIsRecording = false /// if one slot is recording
    
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
                ButtonSlot(slot: $slots[0], canRecord: $canRecord, oneIsRecording: $oneIsRecording)
                ButtonSlot(slot: $slots[1], canRecord: $canRecord, oneIsRecording: $oneIsRecording)
                ButtonSlot(slot: $slots[2], canRecord: $canRecord, oneIsRecording: $oneIsRecording)
            }
            HStack{
                ButtonSlot(slot: $slots[3], canRecord: $canRecord, oneIsRecording: $oneIsRecording)
                ButtonSlot(slot: $slots[4], canRecord: $canRecord, oneIsRecording: $oneIsRecording)
                ButtonSlot(slot: $slots[5], canRecord: $canRecord, oneIsRecording: $oneIsRecording)
                
            }
            HStack{
                ButtonSlot(slot: $slots[6], canRecord: $canRecord, oneIsRecording: $oneIsRecording)
                ButtonSlot(slot: $slots[7], canRecord: $canRecord, oneIsRecording: $oneIsRecording)
                ButtonSlot(slot: $slots[8], canRecord: $canRecord, oneIsRecording: $oneIsRecording)
                
            }
            HStack{
                ButtonSlot(slot: $slots[9], canRecord: $canRecord, oneIsRecording: $oneIsRecording)
                ButtonSlot(slot: $slots[10], canRecord: $canRecord, oneIsRecording: $oneIsRecording)
                ButtonSlot(slot: $slots[11], canRecord: $canRecord, oneIsRecording: $oneIsRecording)
                
            }
            
        }
        .padding()
        
    }
}
struct ButtonSlot: View {
    @Binding var slot: Slot
    @Binding var canRecord: Bool /// whether recording is enabled for all slots
    @Binding var oneIsRecording: Bool /// whether 1 slot is recording (disable recording for other slots)
    
    var body: some View{
        Button(action:{
            if canRecord {
                if slot.isRecording {
                    slot.isRecording = false
                    oneIsRecording = false
                } else if oneIsRecording {
                    print("One slot is already recording")
                } else {
                    slot.isRecording = true
                    oneIsRecording = true
                }
            }
        }) {
            ZStack{
                Rectangle()
                    .cornerRadius(20)
                    .foregroundColor(
                        (canRecord && (!oneIsRecording || slot.isRecording))
                            ? .green
                            : .gray
                    )
                    .animation(
                        (canRecord && (!oneIsRecording || slot.isRecording))
                            ? Animation.default.repeatForever(autoreverses: true)
                            : .default, /// stop animation if `canRecord` is false
                        value: (canRecord && (!oneIsRecording || slot.isRecording)) /// whenever this changes from True to False or vice versa, the animation will update
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
