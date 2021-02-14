//
//  SettingsViewModel.swift
//  WLED Switch
//
//  Created by Roman Gille on 31.01.21.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {

    @Published var hostname: String
    @Published private(set) var states: [LEDStatus]
    @Published var showEditView: Bool = false
    private var editingStatusIndex: Int?

    var statusToEdit: LEDStatus? {
        editingStatusIndex.map { states[$0] }
    }

    init(host: String, states: [LEDStatus]) {
        self.hostname = host
        self.states = states
    }

    private func index(for status: LEDStatus) -> Int? {
        states.firstIndex(where: { $0.id == status.id })
    }

    func updateStatus(with status: LEDStatus) {
        showEditView = false
        editingStatusIndex.map { states[$0] = status }
    }

    func addStatus(_ status: LEDStatus) {
        showEditView = false
        states.append(status)
    }

    func remove(_ status: LEDStatus) {
        states.removeAll { $0.id == status.id }
    }

    func showEditView(for status: LEDStatus) {
        editingStatusIndex = index(for: status)
        showEditView = true
    }

    func showAddStatusView() {
        editingStatusIndex = nil
        showEditView = true
    }
}
