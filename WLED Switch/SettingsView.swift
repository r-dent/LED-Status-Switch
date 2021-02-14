//
//  SettingsView.swift
//  WLED Switch
//
//  Created by Roman Gille on 25.01.21.
//

import SwiftUI
import ColorPickerRing
import DynamicColor

protocol SettingsViewDelegate: AnyObject {
    func settingsViewDidSubmit(_ view: SettingsView, host: String, states: [LEDStatus])
}

struct SettingsView: View {

    @ObservedObject var viewModel: SettingsViewModel

    weak var delegate: SettingsViewDelegate?

    var body: some View {

        VStack(alignment: .leading) {
            Form {
                HStack {
                    Text("Host")
                    TextField("http://192.168.X.X", text: $viewModel.hostname)
                }
                ForEach(viewModel.states) { status in
                    HStack {
                        Circle()
                            .frame(width: 22, height: 22, alignment: .leading)
                            .foregroundColor(Color(status.color))
                        Text(status.title)
                        Spacer()
                        Button("edit") { viewModel.showEditView(for: status) }
                        Button("delete") { viewModel.remove(status) }
                    }
                }
                HStack {
                    Button("+", action: viewModel.showAddStatusView)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button("OK", action: submit)
                        .frame(width: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
        .sheet(isPresented: $viewModel.showEditView) {

            if let status = viewModel.statusToEdit {
                StatusEditView(
                    status: status,
                    onCancel: { viewModel.showEditView = false },
                    onDone: { viewModel.updateStatus(with: $0) }
                )
            } else {
                StatusEditView(
                    onCancel: { viewModel.showEditView = false },
                    onDone: { viewModel.addStatus($0) }
                )
            }
        }
    }

    func submit() {
        delegate?.settingsViewDidSubmit(self, host: viewModel.hostname, states: viewModel.states)
    }
}


struct SettingsView_Previews: PreviewProvider {

    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(host: "testhost", states: LEDStatus.all), delegate: nil)
            .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
