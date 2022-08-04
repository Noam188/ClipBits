import AVKit
import SwiftUI

struct Linked: View{
    @Binding var text:String
    var body: some View {
        HStack{
            VStack{
                Button(action:{
                    print("hi")
                }){
                    VStack{
                        Image(systemName: "link.circle")
                          .font(.system(size: 30))
                        Text(text)
                    }
                }
            }
        }
    }
}
