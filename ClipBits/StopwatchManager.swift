import SwiftUI
class StopWatchManager: ObservableObject {
    @Published var secondsElapsed = 3
    @Published var stopWatchSeconds = 0
    @Published var displaySeconds = 1
    @Published var bars = 1
    @Published var mode: StopWatchMode = .stopped
    @Published var timer = Timer()
    @Published var tempo:CGFloat = 120
    @Published var autoStop = false
    @Published var numberOfBeats = 1
    var countDown = false
    
    enum StopWatchMode {
        case running
        case stopped
        case paused
    }
    private var timeInterval: TimeInterval {
        return 1 / ((Double(tempo) / 60.0))
    }
    
    func start() {
        stopWatchSeconds = -1 * secondsElapsed
        self.countDown = true
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {
            _ in
            if self.displaySeconds == 4{
                self.displaySeconds = 1
            }
            else{
                self.displaySeconds = 1 + self.displaySeconds
            }
            self.stopWatchSeconds = 1 + self.stopWatchSeconds
            if self.countDown{
                self.secondsElapsed = -1 + self.secondsElapsed
                if self.secondsElapsed == -1{
                    self.countDown = false
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

class LoopWatch:ObservableObject{
    @Published var timer = Timer()
    @Published var secondsElapsed = -1
    @Published var isRunning = false
    @EnvironmentObject var stopWatchManager:StopWatchManager
    @State var quantize = 8.0
    
    private var timeInterval: TimeInterval {
        return 1 / ((Double(120) / 60.0) * quantize)
    }
     func start() {
         isRunning = true
         self.secondsElapsed = 0
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {_ in
            self.secondsElapsed += 1
            print(self.secondsElapsed)
        }
    }
    func stop() {
        isRunning = false
        self.secondsElapsed = 0
        timer.invalidate()
       }
}