//import SwiftUI
//
//struct Start: View {
//    @State var boardList: [BoardList] = [
//        BoardList(name: "mySoundBoard")
//    ]
//    @State var showingSheet = false
//    @State var text = ""
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Button("Add item") {
//                    showingSheet = true
//                }
//
//                List(boardList) { boardItem in
//                    NavigationLink(destination: ContentView()) {
//                        HStack {
//                            Text(boardItem.name)
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("Your ClipBits")
//        }
//        .sheet(isPresented: $showingSheet) {
//            let newBoard = BoardList(name: text)
//            boardList.append(newBoard)
//            text = ""
//        } content: {
//            TextField("Enter new name", text: $text)
//                .padding()
//        }
//    }
//}
//struct BoardList: Identifiable{
//    let id = UUID()
//    let name: String
//}
//struct Start_Previews: PreviewProvider {
//    static var previews: some View {
//        Start()
//    }
//}
