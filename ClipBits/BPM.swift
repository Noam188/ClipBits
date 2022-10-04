

import SwiftUI

struct BPM: View{
    @Binding var tempo:Int
    @EnvironmentObject var stopWatchManager:StopWatchManager
    @EnvironmentObject var recTimer:RecTimer
    var body: some View {
        HStack{
            Button(action: {
                tempo -= 1
                stopWatchManager.tempo -= 1
                recTimer.tempo -= 1
            }) {
                ZStack{
                    Triangle()
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 75, height: 65)
                        .shadow(radius: 3)
                    
                    Text("-")
                        .foregroundColor(.black)
                        .font(.system(size: 50))
                        .padding(.leading,20)
                        .padding(.bottom,10)
                }
            }
            ZStack{
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                Text("\(Int(tempo))")
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .fontWeight(.light)
                
            }.frame(width: 75, height: 75)
            Button(action: {
                tempo += 1
                stopWatchManager.tempo += 1
                recTimer.tempo += 1
            }) {
                ZStack{
                    Triangle()
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(90))
                        .frame(width: 75, height: 65)
                        .shadow(radius: 3)

                    Text("+")
                        .foregroundColor(.black)
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
//        path.addArc(tangent1End: CGPoint(x: rect.midX, y: rect.minY), tangent2End:  CGPoint(x: rect.minX, y: rect.maxY), radius:10)
//        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY), tangent2End:  CGPoint(x: rect.maxX, y: rect.maxY), radius:10)
//        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY), tangent2End:  CGPoint(x: rect.midX, y: rect.minY), radius:10)
//        path.closeSubpath()

        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
