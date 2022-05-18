import SwiftUI
struct Slot: Identifiable {
    var id: String
    var isChecked = false
    var isRecording = false
    var beenRecorded: Bool?
    var isTrimming = false
    
    init(id: String) {
        self.id = id
        isChecked = false
        isRecording = false
        isTrimming = false
        beenRecorded = UserDefaults.standard.bool(forKey: id)
    }
}
