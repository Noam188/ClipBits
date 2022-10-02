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
    var preset = ""
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
        beenRecorded = beenRecordedDef.bool(forKey: id)
        isLooping = isLoopingDef.bool(forKey: id)
        loopArr = (loopArrDef.object(forKey: self.id) as? [[Bool]]) ?? [[Bool]]()
        preset = presetDef.string(forKey: self.id) ?? ""
        isLinked = [false,false,false,false]
    }
}
