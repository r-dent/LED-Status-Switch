//
//  StatusEditView.swift
//  WLED Switch
//
//  Created by Roman Gille on 31.01.21.
//

import SwiftUI
import ColorPickerRing

struct StatusEditView: View {

    @State var title: String = ""
    @State var color: NSColor = .orange

    let editingStatus: LEDStatus?
    let onDone: (LEDStatus) -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack {
            ColorPickerRing(color: $color, strokeWidth: 20)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            TextField("Status name", text: $title)
            Spacer().frame(height: 16)
            HStack {
                Button("cancel", action: onCancel)
                Button("done", action: _onDone)
            }
        }
        .padding()
        .frame(width: 200)
        .onAppear {
            title = editingStatus?.title ?? ""
            color = editingStatus?.color ?? .orange
        }
    }

    init(status: LEDStatus? = nil, onCancel: @escaping () -> Void, onDone: @escaping (LEDStatus) -> Void) {

        self.onDone = onDone
        self.onCancel = onCancel
        self.editingStatus = status
    }

    private func _onDone() {
        onDone(LEDStatus(title: title, color: color))
    }
}

struct StatusEditView_Previews: PreviewProvider {

    static var previews: some View {
        StatusEditView(onCancel: {}, onDone: { _ in })
            .frame(width: 300)
            .background(Color.secondary)
    }
}

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.blue : Color.white)
            .background(configuration.isPressed ? Color.white : Color.blue)
            .cornerRadius(6.0)
            .padding()
    }
}
