import SwiftUI
struct Slot: Identifiable {
    @ObservedObject var audioPlayer = AudioPlayer()
    var id: String
    var isChecked = false
    var isRecording = false
    var beenRecorded = false
    var isTrimming = false
    var loopEdit = false
    var loopArr = [[Bool]]()
    var isLooping = false
    var preset:String
    var isLinked = [false,false,false,false]
    var loopArrDef = UserDefaults.standard
    var presetDef = UserDefaults.standard
    var beenRecordedDef = UserDefaults.standard
    var isLoopingDef = UserDefaults.standard
    init(id: String) {
        self.id = id
        loopEdit = false
        isChecked = false
        isRecording = false
        isTrimming = false
        beenRecorded = UserDefaults.standard.bool(forKey: "b\(self.id)")
        isLooping = UserDefaults.standard.bool(forKey: "l\(self.id)")
        loopArr = (UserDefaults.standard.object(forKey: "arr\(self.id)") as? [[Bool]]) ?? [[Bool]]()
        preset = UserDefaults.standard.string(forKey: "p\(self.id)") ?? ""
        isLinked = [false,false,false,false]
    }
//    func clear(){
//        loopEdit = false
//        self.isChecked = false
//        self.isRecording = false
//        self.isTrimming = false
//        self.beenRecorded = false
//        self.isLooping = false
//        self.loopArr = [[Bool]]()
//        self.preset = ""
//        self.isLinked = [false,false,false,false]
//    }
}
