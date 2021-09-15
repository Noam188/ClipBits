
import SwiftUI

/// put each slot's state in a reusable struct, makes things more organized
/// plus you can also add other properties that are independent to each slot
struct Slot: Identifiable {
    var id: String
    var isChecked = false
    var isRecording = false
    var beenRecorded: Bool?
    
    init(id: String) {
        self.id = id
        self.isChecked = false
        self.isRecording = false
        self.beenRecorded = UserDefaults.standard.bool(forKey: id)
    }
}

struct ContentView: View {
    @StateObject var audioRecorder = AudioRecorder()
    @State var canRecord = false /// this is for enabling/disabling universal recording ability
    @State var oneIsRecording = false /// if one slot is recording
    @State var edit = false
    @State var slots = [
        Slot(id: "slot0"),
        Slot(id: "slot1"),
        Slot(id: "slot2"),
        Slot(id: "slot3"),
        Slot(id: "slot4"),
        Slot(id: "slot5"),
        Slot(id: "slot6"),
        Slot(id: "slot7"),
        Slot(id: "slot8"),
        Slot(id: "slot9"),
        Slot(id: "slot10"),
        Slot(id: "slot11")
    ]
    
    func hasAtLeastOneChecked() -> Bool {
        var numberOfChecked = 0
        for slot in slots {
            if slot.isChecked {
                numberOfChecked += 1
            }
        }
        if numberOfChecked > 0 {
            return true
        } else {
            return false
        }
    }
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    if hasAtLeastOneChecked() {
                        for index in slots.indices{
                            if slots[index].isChecked{
                                slots[index].beenRecorded = false
                            }
                            slots[index].isChecked = false
                        }
                        edit.toggle()
                    } else {
                        edit.toggle()
                    }
                }) {
                    if hasAtLeastOneChecked() && edit{
                        Image(systemName: "trash.circle.fill")
                            .font(.system(size:45))
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: edit ? "pencil.circle.fill" : "pencil.circle")
                            .font(.system(size:45))
                            .foregroundColor(edit ? .blue : .black)
                    }
                }
                
                Button(action:{
                    canRecord.toggle()
                }) {
                    Image(systemName: canRecord ? "mic.circle.fill" : "mic.circle")
                        .font(.system(size:45))
                        .foregroundColor(canRecord ? .red : .black)
                }
                Text("Press the mic, then select the slot you'd like to record on")
                
            }
            HStack{
                ButtonSlot(slot: $slots[0], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit,  audioRecorder: audioRecorder, index: 0)
                ButtonSlot(slot: $slots[1], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit,  audioRecorder: audioRecorder, index: 1)
                ButtonSlot(slot: $slots[2], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit,  audioRecorder: audioRecorder, index: 2)
            }
            HStack{
                ButtonSlot(slot: $slots[3], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit,    audioRecorder: audioRecorder, index: 3)
                ButtonSlot(slot: $slots[4], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit,   audioRecorder: audioRecorder, index: 4)
                ButtonSlot(slot: $slots[5], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit,  audioRecorder: audioRecorder, index: 5)
                
            }
            HStack{
                ButtonSlot(slot: $slots[6], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit,  audioRecorder: audioRecorder, index: 6)
                ButtonSlot(slot: $slots[7], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit,  audioRecorder: audioRecorder, index: 7)
                ButtonSlot(slot: $slots[8], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit,   audioRecorder: audioRecorder, index: 8)
                
            }
            HStack{
                ButtonSlot(slot: $slots[9], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit,  audioRecorder: audioRecorder, index: 9)
                ButtonSlot(slot: $slots[10], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit,   audioRecorder: audioRecorder, index: 10)
                ButtonSlot(slot: $slots[11], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit,  audioRecorder: audioRecorder, index: 11)
                
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
