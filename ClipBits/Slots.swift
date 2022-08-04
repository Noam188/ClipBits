import SwiftUI
struct Slot: Identifiable {
    var id: String
    var isChecked = false
    var isRecording = false
    var beenRecorded: Bool?
    var isTrimming = false
    var loopEdit = false
    var loopArr = [[Bool]]()
    var isLooping = false
    var preset:String? = nil
    var isLinked1 = false
    var isLinked2 = false
    var isLinked3 = false
    var isLinked4 = false
    init(id: String) {
        self.id = id
        loopEdit = false
        isChecked = false
        isRecording = false
        isTrimming = false
        isLooping = false
        loopArr = [[Bool]]()
        preset = nil
        isLinked1 = false
        isLinked2 = false
        isLinked3 = false
        isLinked4 = false
        beenRecorded = UserDefaults.standard.bool(forKey: id)
    }
}
