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
        HStack(spacing: 20){
            ImageButton(imageName: "repeat.circle.fill", imageNameAlt: "repeat.circle", dependent: loopState, buttonColor: .green){
                if edit == false, canRecord == false {
                    loopState.toggle()
                }
                
            }.frame(width: 55, height: 55)
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
                }.frame(width: 55, height: 55)
            }
            else{
                ImageButton(imageName: "pencil.circle.fill", imageNameAlt: "pencil.circle", dependent: edit, buttonColor: .blue){
                    if canRecord == false, loopState == false{
                        edit.toggle()
                    }
                }.frame(width: 55, height: 55)
            }
            ImageButton(imageName: "gearshape.fill" , imageNameAlt: "gearshape", dependent: showSettings, buttonColor: .orange){
                    if edit == false, canRecord == false {
                        showSettings.toggle()
                    }
            }.sheet(isPresented: $showSettings, content: {SettingsView( metronome: $metronome)})
            .frame(width: 55, height: 55)
            ImageButton(imageName: "mic.circle.fill", imageNameAlt: "mic.circle", dependent: canRecord, buttonColor: .red){
                if loopState == false, edit == false, oneIsRecording == false{
                    canRecord.toggle()
                    stopWatchManager.secondsElapsed = Int(num)
                    
                }
            }.frame(width: 55, height: 55)

            
            Button(action: {
                if num == 4 {
                    num = 8
                } else if num == 8{
                    num = 16
                }
                else{
                    num = 4
                }
            }) {
                Text("\(Int(num))")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .frame(width: 55, height: 55)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.black, lineWidth: 4)
                            .frame(width: 53, height: 53)
                    )
            }
        }
    }
}
