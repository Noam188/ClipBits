import SwiftUI
struct ImageButton: View {
    let imageName: String
    let imageNameAlt: String
    let dependent: Bool
    let buttonColor: Color
    let action: (() -> Void)
    var body: some View {
        Button(action: action) {
            Image(systemName: dependent ? imageName : imageNameAlt)
                .foregroundColor(dependent ? buttonColor : .black)
                .font(.system(size: 50))
        }
    }
}
struct ControlPannel: View{
    @Binding var canRecord:Bool
    @Binding var loopState:Bool
    @Binding var edit:Bool
    @Binding var num:CGFloat
    @Binding var slots:[Slot]
    @Binding var oneIsRecording:Bool
    @Binding var showSettings: Bool
    @Binding var metronome:Bool
    @EnvironmentObject var stopWatchManager:StopWatchManager
    @State var font = 33
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
        HStack(){
            ImageButton(imageName: "repeat.circle.fill", imageNameAlt: "repeat.circle", dependent: loopState, buttonColor: .green){
                if edit == false, canRecord == false {
                    loopState.toggle()
                }
                
            }
            if hasAtLeastOneChecked() && edit {
                Button(action: {
                    if canRecord == false, loopState == false{
                        if hasAtLeastOneChecked() {
                            for index in slots.indices {
                                if slots[index].isChecked {
                                    slots[index].beenRecorded = false
                                    UserDefaults.standard.set(false, forKey: slots[index].id)
                                }
                                slots[index].isChecked = false
                            }
                            edit.toggle()
                        }
                    }
                }) {
                        Image(systemName: "trash.circle.fill")
                            .font(.system(size: 45))
                            .foregroundColor(.red)
                }
            }
            else{
                ImageButton(imageName: "pencil.circle.fill", imageNameAlt: "pencil.circle", dependent: edit, buttonColor: .blue){
                    if canRecord == false, loopState == false{
                        edit.toggle()
                    }
                }
            }
            ImageButton(imageName: "gearshape.fill" , imageNameAlt: "gearshape", dependent: showSettings, buttonColor: .orange){
                    if edit == false, canRecord == false {
                        showSettings.toggle()
                    }
            }.sheet(isPresented: $showSettings, content: {SettingsView( metronome: $metronome)})
            ImageButton(imageName: "mic.circle.fill", imageNameAlt: "mic.circle", dependent: canRecord, buttonColor: .red){
                if loopState == false, edit == false, oneIsRecording == false{
                    stopWatchManager.secondsElapsed = Int(num)
                    canRecord.toggle()
                }
            }
            
            Button(action: {
                if num == 3 {
                    num = 7
                } else if num == 7{
                    num = 15
                    font = 20
                }
                else{
                    num = 3
                    font = 33
                }
            }) {
                Text("\(Int(num+1))")
                    .font(.system(size: CGFloat(font)))
                    .foregroundColor(.black)
                    .padding()
                    .overlay(
                        Circle()
                            .strokeBorder(Color.black, lineWidth: 4)
                    ).frame(width: 60, height: 60)
            }
        }
    }
}
