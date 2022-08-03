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
    init(id: String) {
        self.id = id
        loopEdit = false
        isChecked = false
        isRecording = false
        isTrimming = false
        isLooping = false
        loopArr = [[Bool]]()
        preset = nil
        beenRecorded = UserDefaults.standard.bool(forKey: id)
    }
}
