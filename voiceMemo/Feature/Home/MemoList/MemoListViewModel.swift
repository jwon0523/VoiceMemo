//
//  MemoListViewModel.swift
//  voiceMemo
//

import Foundation

class MemoListViewModel: ObservableObject {
    @Published var memos: [Memo]
    @Published var isEditMemoMode: Bool
    @Published var removeMemos: [Memo]
    @Published var isDisplayRemoveMemoAlert: Bool
    
    var removeMemoCount: Int {
        return removeMemos.count
    }
    var navigationBarRightBtnMode: NavigationBtnType {
        isEditMemoMode ? .complete : .edit
    }
    
    init(
        memos: [Memo] = [],
        isEditMemoMode: Bool = false,
        removeMemos: [Memo] = [],
        isDisplayRemoveMemoAlert: Bool = false
    ) {
        self.memos = memos
        self.isEditMemoMode = isEditMemoMode
        self.removeMemos = removeMemos
        self.isDisplayRemoveMemoAlert = isDisplayRemoveMemoAlert
    }
}

extension MemoListViewModel {
    func addMemo(_ memo: Memo) {
        memos.append(memo)
    }
    
    func updateMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos[index] = memo
        }
    }
    
    func removeMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos.remove(at: index)
        }
    }
    
    func navigationRightBtnTapped() {
        if isEditMemoMode {
            if removeMemos.isEmpty {
                isEditMemoMode = false
            } else {
                setIsDisplayRemoveMemoAlert(true)
            }
        } else {
            isEditMemoMode = true
        }
    }
    
    func setIsDisplayRemoveMemoAlert(_ isDisplay: Bool) {
        isDisplayRemoveMemoAlert = isDisplay
    }
    
    func memoRemoveSelectedBoxTapped(_ memo: Memo) {
        // removeMemos에 있는 값과 메모가 같으면 지우면서 삭제 취소
        if let index = removeMemos.firstIndex(of: memo) {
            removeMemos.remove(at: index)
        } else {
            removeMemos.append(memo)
        }
    }
    
    func removeBtnTapped() {
        // memos를 순회하면서 removeMemos에 있는 값과 일치한 memo들 전부 삭제
        memos.removeAll { memo in
            removeMemos.contains(memo)
        }
        // 삭제 체크시 removeMemos에 쌓인 값도 모두 제거
        removeMemos.removeAll()
        isEditMemoMode = false
    }
}
