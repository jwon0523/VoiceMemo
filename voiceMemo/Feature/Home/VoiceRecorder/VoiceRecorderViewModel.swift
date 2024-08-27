//
//  VoiceRecorderViewModel.swift
//  voiceMemo
//

import AVFoundation

class VoiceRecorderViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isDisplayRemoveVoiceRecorderAlert: Bool
    @Published var isDisplayErrorAlert: Bool
    @Published var errorAlertMessage: String
    
    /// 음성메모 녹음 관련 프로퍼티
    @Published var isRecording: Bool
    
    /// 음성메모 재생 관련 프로퍼티
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool
    @Published var isPaused: Bool
    @Published var playedTime: TimeInterval
    private var progressTime: Timer?
    
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
        self.isDisplayErrorAlert = isDisplayErrorAlert
        self.errorAlertMessage = errorAlertMessage
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
        // TODO: -삭제 얼럿 노출을 위한 상태 변경 메서드 호출
    }
    
    func removeSelectedVoiceRecord() {
        guard let fileToRemove = selectedRecoredFile,
              let indextToRemove = recordedFiles.firstIndex(of: fileToRemove) else {
            // TODO: - 선택된 음성메모를 찾을 수 없다는 에러 얼럿 노출
            return
        }
        
        do {
            try FileManager.default.removeItem(at: fileToRemove)
            recordedFiles.remove(at: indextToRemove)
            selectedRecoredFile = nil
            // TODO: - 재생 정지 메서드 호출
            // TODO: - 삭제 성공 얼럿 노출
        } catch {
            // TODO: - 삭제 실패 오류 얼럿 노출
        }
    }
    
    private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
        isDisplayRemoveVoiceRecorderAlert = isDisplay
    }
    
    private func setErrorAlertMessage(_ message: String) {
        errorAlertMessage = message
    }
    
    private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
        isDisplayErrorAlert = isDisplay
    }
    
    private func displayError(message: String) {
        setErrorAlertMessage(message)
        setIsDisplayErrorAlert(true)
    }
}
