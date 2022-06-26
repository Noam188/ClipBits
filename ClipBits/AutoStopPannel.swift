
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var stopWatchManager:StopWatchManager
    @Binding var metronome:Bool
    var body: some View {
        VStack{
            Toggle("Metronome", isOn: $metronome)
                .padding(.horizontal)
            Toggle("Record measures", isOn: $stopWatchManager.autoStop)
                .padding(.horizontal)
            HStack{
                Text("Number of bars")
                    .foregroundColor(stopWatchManager.autoStop ? .black : .gray)
                Spacer()
                
                HStack{
                    Button(action: {
                        
                        stopWatchManager.numberOfBeats += 1
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 25))
                    }
                    Text("\(stopWatchManager.numberOfBeats)")
                        .font(.system(size: 20))
                        .background(Color.white)
                        .cornerRadius(5)
                        .padding(.horizontal)
                    Button(action: {
                        if stopWatchManager.numberOfBeats > 1{
                            stopWatchManager.numberOfBeats -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 25))
                    }
                }
            }.padding(.horizontal)
                .disabled(!stopWatchManager.autoStop)
        }
        
    }
}
