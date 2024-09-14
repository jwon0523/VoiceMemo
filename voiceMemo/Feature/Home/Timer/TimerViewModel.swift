//
//  TimerViewModel.swift
//  voiceMemo
//

import Foundation

class TimerViewModel: ObservableObject {
  @Published var isDisplaySetTimeView: Bool
  @Published var time: Time
  @Published var timer: Timer?
  @Published var timeRemaining: Int
  @Published var isPaused: Bool
  
  init(
    isDisplaySetTimeView: Bool = true,
    time: Time = .init(hours: 0, minutes: 0, seconds: 0),
    timer: Timer? = nil,
    timeRemaining: Int = 0,
    isPaused: Bool = false
  ) {
    self.isDisplaySetTimeView = isDisplaySetTimeView
    self.time = time
    self.timer = timer
    self.timeRemaining = timeRemaining
    self.isPaused = isPaused
  }
}

extension TimerViewModel {
  func settingBtnTapped() {
    isDisplaySetTimeView = false
    timeRemaining = time.convertedSeconds
    startTimer()
  }
  
  func cancelBtnTapped() {
    stopTimer()
    isDisplaySetTimeView = true
  }
  
  func pauseOrRestartBtnTapped() {
    if isPaused {
      startTimer()
    } else {
      timer?.invalidate()
      timer = nil
    }
    isPaused.toggle()
  }
}

private extension TimerViewModel {
  func startTimer() {
    guard timer == nil else { return }
    timer = Timer.scheduledTimer(
      withTimeInterval: 1,
      repeats: true
    ) { [weak self]_ in
      // 클로저 내에 self를 명시하여 Timer 객체가 아닌
      // TimerViewModel를 참조하는 것임을 명확히 해줘야 함
      guard let self = self else { return } // 객체가 해제되었는지 확인
      if self.timeRemaining > 0 {
        self.timeRemaining -= 1
      } else {
        self.stopTimer()
      }
    }
  }
  
  func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
}
