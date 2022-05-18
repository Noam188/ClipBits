

import SwiftUI

struct BPM: View{
    @EnvironmentObject var stopWatchManager:StopWatchManager
    var body: some View {
        HStack{
            Button(action: {
                stopWatchManager.tempo -= 1
            }) {
                ZStack{
                    Triangle()
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 75, height: 65)
                    Text("-")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                        .padding(.leading,20)
                        .padding(.bottom,10)
                }
            }
            ZStack{
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                Text("\(Int(stopWatchManager.tempo))")
                    .font(.system(size: 30))
                    .fontWeight(.light)
                
            }.frame(width: 75, height: 75)
            Button(action: {
                stopWatchManager.tempo += 1
            }) {
                ZStack{
                    Triangle()
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(90))
                        .frame(width: 75, height: 65)
                    Text("+")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                        .padding(.trailing,20)
                        .padding(.bottom,10)
                }
            }
        }
    }
}
struct Triangle:Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}
