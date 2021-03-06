
import SwiftUI
struct ButtonReduced: View{
    @StateObject var audioRecorder = AudioRecorder()
    @Binding var slots:[Slot]
    @Binding var canRecord:Bool/// this is for enabling/disabling universal recording ability
    @Binding var oneIsRecording:Bool/// if one slot is recording
    @Binding var edit:Bool
    @Binding var num: CGFloat
    @Binding var loopState:Bool
    @EnvironmentObject var stopWatchManager:StopWatchManager

    var body: some View {
        VStack{
            HStack {
                ButtonSlot(slot: $slots[0], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, audioRecorder: audioRecorder, index: 0).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[1], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, audioRecorder: audioRecorder, index: 1).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[2], canRecord: $canRecord, oneIsRecording: $oneIsRecording,  edit: $edit, loopState: $loopState, audioRecorder: audioRecorder, index: 2).environmentObject(stopWatchManager)
            }
            HStack {
                ButtonSlot(slot: $slots[3], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, audioRecorder: audioRecorder, index: 3).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[4], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, audioRecorder: audioRecorder, index: 4).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[5], canRecord: $canRecord, oneIsRecording: $oneIsRecording,  edit: $edit, loopState: $loopState, audioRecorder: audioRecorder, index: 5).environmentObject(stopWatchManager)
            }
            HStack {
                ButtonSlot(slot: $slots[6], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, audioRecorder: audioRecorder, index: 6).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[7], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, audioRecorder: audioRecorder, index: 7).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[8], canRecord: $canRecord, oneIsRecording: $oneIsRecording,  edit: $edit, loopState: $loopState, audioRecorder: audioRecorder, index: 8).environmentObject(stopWatchManager)
            }
            HStack {
                ButtonSlot(slot: $slots[9], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, audioRecorder: audioRecorder, index: 9).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[10], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, audioRecorder: audioRecorder, index: 10).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[11], canRecord: $canRecord, oneIsRecording: $oneIsRecording,  edit: $edit, loopState: $loopState, audioRecorder: audioRecorder, index: 11).environmentObject(stopWatchManager)
            }
        }
    }
}
