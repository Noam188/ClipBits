
import SwiftUI
struct ButtonReduced: View{
    @StateObject var audioRecorder = AudioRecorder()
    @Binding var slots:[Slot]
    @Binding var canRecord:Bool/// this is for enabling/disabling universal recording ability
    @Binding var oneIsRecording:Bool/// if one slot is recording
    @Binding var edit:Bool
    @Binding var num: CGFloat
    @Binding var loopState:Bool
    @Binding var oneIsLooping:Bool
    @Binding var canLink1:Bool
    @Binding var canLink2:Bool
    @Binding var canLink3:Bool
    @Binding var canLink4:Bool
    @EnvironmentObject var stopWatchManager:StopWatchManager
    func findIndex()->Int{
        for index in slots.indices {
            if slots[index].loopEdit {
                return Int(index)
            }
        }
        return 0
    }
    var body: some View {
        if !oneIsLooping{
        VStack(spacing:10){
            HStack(spacing:10){
                ButtonSlot(slot: $slots[0], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: 0).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[1], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: 1).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[2], canRecord: $canRecord, oneIsRecording: $oneIsRecording,  edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: 2).environmentObject(stopWatchManager)
            }
            HStack(spacing:10){
                ButtonSlot(slot: $slots[0], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: 0).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[1], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: 1).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[2], canRecord: $canRecord, oneIsRecording: $oneIsRecording,  edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: 2).environmentObject(stopWatchManager)
            }
            HStack(spacing:10){
                ButtonSlot(slot: $slots[0], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: 0).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[1], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: 1).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[2], canRecord: $canRecord, oneIsRecording: $oneIsRecording,  edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: 2).environmentObject(stopWatchManager)
            }
            HStack(spacing:10){
                ButtonSlot(slot: $slots[0], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: 0).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[1], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: 1).environmentObject(stopWatchManager)
                ButtonSlot(slot: $slots[2], canRecord: $canRecord, oneIsRecording: $oneIsRecording,  edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: 2).environmentObject(stopWatchManager)
            }
        }
        } else {
            ButtonSlot(slot: $slots[findIndex()], canRecord: $canRecord, oneIsRecording: $oneIsRecording, edit: $edit, loopState: $loopState, oneIsLooping: $oneIsLooping, canLink1: $canLink1, canLink2: $canLink2, canLink3: $canLink3, canLink4: $canLink4, audioRecorder: audioRecorder, index: findIndex()).environmentObject(stopWatchManager)
        }
    }
}
