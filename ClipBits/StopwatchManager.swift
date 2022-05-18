import SwiftUI
class StopWatchManager: ObservableObject {
    @Published var secondsElapsed = 4
    @Published var stopWatchSeconds = 0
    @Published var displaySeconds = 1
    @Published var bars = 1
    @Published var mode: StopWatchMode = .stopped
    @Published var timer = Timer()
    @Published var tempo:CGFloat = 120
    @Published var autoStop = false
    @Published var numberOfMeasures = 1
    @Published var measuresRecorded = 0
    var countDown = false
    
    enum StopWatchMode {
        case running
        case stopped
        case paused
    }
    
    func start() {
        stopWatchSeconds = -1 * secondsElapsed
        self.countDown = true
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 60 / tempo, repeats: true) { _ in
            self.stopWatchSeconds = 1 + self.stopWatchSeconds
            if self.countDown{
                self.secondsElapsed = -1 + self.secondsElapsed
                if self.secondsElapsed == 0{
                    self.countDown = false
                }
            }
            else{
                if self.displaySeconds == 4{
                    self.displaySeconds = 1
                }
                else{
                    self.displaySeconds = 1 + self.displaySeconds
                }
            }
        }
    }
    
    func stop() {
        timer.invalidate()
        mode = .stopped
        displaySeconds = 1
        stopWatchSeconds = 0
    }
}

