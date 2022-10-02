import SwiftUI

 struct Start: View{
    @State var boardList: [BoardList] = [BoardList(name: "mySoundBoard")]
    @State var showingSheet = false
    @State var text = ""

    var body: some View {
        NavigationView {
//            ScrollView{
//                ZStack{
            VStack {
                List{
                    ForEach(boardList) { boardItem in
                        NavigationLink(
                            destination: boardList[boardItem.num].clipBit
                                .navigationTitle(boardList[boardItem.num].name)
                                .navigationBarTitleDisplayMode(.inline)
                        ){
                            HStack {
                                Text(boardItem.name)
                            }
                        }
                          }.onDelete { boardItem in
                              boardList.remove(atOffsets: boardItem)
                            }
                }
            }
//        }.background(LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .topLeading, endPoint: .bottomTrailing))
//            }
            .navigationBarTitle("Your ClipBits")
            .navigationBarItems(trailing: Button(action: {
                    showingSheet = true
                     }) {
                         Image(systemName: "plus")
                     })
        }
        .sheet(isPresented: $showingSheet) {
            let newBoard = BoardList(name: text)
            boardList.append(newBoard)
            for i in 0...boardList.count-1{
                boardList[i].num = i
            }
            text = ""
        } content: {
            VStack{
                HStack{
                Button(action: {
                    showingSheet = false
                }){
                    Text("Done")
                        .foregroundColor(.blue)
                }.padding()
                    Spacer()
            }
                Spacer()
            TextField("Enter new name", text: $text)
                .padding()
                .background(Color.white)
                .shadow(radius: 1)
                Spacer()
            }
        }
    }
}
struct BoardList: Identifiable{
    let id = UUID()
    let name: String
    let clipBit:ContentView
    var num = 0
    init(name:String){
        self.name = name
        clipBit = ContentView(id:name)
    }
}
struct Start_Previews: PreviewProvider {
    static var previews: some View {
        Start()
    }
}
