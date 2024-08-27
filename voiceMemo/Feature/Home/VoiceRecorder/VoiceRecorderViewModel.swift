//
//  VoiceRecorderViewModel.swift
//  voiceMemo
//

import AVFoundation

class VoiceRecorderViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isDisplayRemoveVoiceRecorderAlert: Bool
    @Published var isDisplayAlert: Bool
    @Published var alertMessage: String
    
    /// 음성메모 녹음 관련 프로퍼티
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording: Bool
    
    /// 음성메모 재생 관련 프로퍼티
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool
    @Published var isPaused: Bool
    @Published var playedTime: TimeInterval
    private var progressTimer: Timer?
    
    /// 음성메모된 파일
    var recordedFiles: [URL]
    
    /// 현재 선택된 음성메모 파일
    @Published var selectedRecoredFile: URL?
    
    init(
        isDisplayRemoveVoiceRecorderAlert: Bool = false,
        isDisplayErrorAlert: Bool = false,
        errorAlertMessage: String = "",
        isRecording: Bool = false,
        isPlaying: Bool = false,
        isPaused: Bool = false,
        playedTime: TimeInterval = 0,
        recordedFiles: [URL] = [],
        selectedRecoredFile: URL? = nil
    ) {
        self.isDisplayRemoveVoiceRecorderAlert = isDisplayRemoveVoiceRecorderAlert
        self.isDisplayAlert = isDisplayErrorAlert
        self.alertMessage = errorAlertMessage
        self.isRecording = isRecording
        self.isPlaying = isPlaying
        self.isPaused = isPaused
        self.playedTime = playedTime
        self.recordedFiles = recordedFiles
        self.selectedRecoredFile = selectedRecoredFile
    }
}

extension VoiceRecorderViewModel {
    func voiceRecordCallTapped(_ recordedFile: URL) {
        if selectedRecoredFile != recordedFile {
            // TODO: - 재생저지 메서드 호출
            selectedRecoredFile = recordedFile
        }
    }
    
    func removeBtnTapped() {
        setIsDisplayRemoveVoiceRecorderAlert(true)
    }
    
    func removeSelectedVoiceRecord() {
        guard let fileToRemove = selectedRecoredFile,
              let indextToRemove = recordedFiles.firstIndex(of: fileToRemove) else {
            displayAlert(message: "선택된 음성메모 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: fileToRemove)
            recordedFiles.remove(at: indextToRemove)
            selectedRecoredFile = nil
            // TODO: - 재생 정지 메서드 호출
            displayAlert(message: "선택된 음성메모 파일을 성공적으로 삭제했습니다.")
        } catch {
            displayAlert(message: "선택된 음성메모 파일 삭제 중 오류가 발생했습니다.")
        }
    }
    
    private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
        isDisplayRemoveVoiceRecorderAlert = isDisplay
    }
    
    private func setErrorAlertMessage(_ message: String) {
        alertMessage = message
    }
    
    private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
        isDisplayAlert = isDisplay
    }
    
    private func displayAlert(message: String) {
        setErrorAlertMessage(message)
        setIsDisplayErrorAlert(true)
    }
}

// MARK: - 음성메모 녹음 관련
extension VoiceRecorderViewModel {
    func recordBtnTapped() {
        selectedRecoredFile = nil
        
        if isPlaying {
            // TODO: - 재생 정지 메서드 호출
            // TODO: - 재생 시작 메서드 호출
        } else if isRecording {
            // TODO: - 녹음 정지 메서드 호출
        } else {
            // TODO: - 녹음 시작 메서드 호출
        }
    }
    
    private func startRecording() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("새로운 녹음 \(recordedFiles.count + 1)")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            self.isRecording = true
        } catch {
            displayAlert(message: "음성메모 녹음 중 오류가 발생했습니다.")
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        self.recordedFiles.append(self.audioRecorder!.url)
        self.isRecording = false
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
