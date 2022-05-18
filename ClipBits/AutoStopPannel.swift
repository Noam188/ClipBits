
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
                Spacer()
                
                HStack{
                    Button(action: {
                        
                        stopWatchManager.numberOfMeasures += 1
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 35))
                    }
                    Text("\(stopWatchManager.numberOfMeasures)")
                        .font(.system(size: 40))
                        .background(Color.white)
                        .cornerRadius(5)
                        .padding(.horizontal)
                    Button(action: {
                        if stopWatchManager.numberOfMeasures > 1{
                            stopWatchManager.numberOfMeasures -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 35))
                    }
                }
            }.padding(.horizontal)
                .disabled(!stopWatchManager.autoStop)
        }
        
    }
}
