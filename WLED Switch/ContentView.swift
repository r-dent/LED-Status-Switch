//
//  ContentView.swift
//  WLED Switch
//
//  Created by Roman Gille on 25.01.21.
//

import SwiftUI

protocol SettingsViewDelegate: AnyObject {
    func settingsViewDidSubmit(_ view: SettingsView, with settings: Settings)
}

struct SettingsView: View {

    @State private var hostname: String = ""

    let settings: Settings
    private weak var delegate: SettingsViewDelegate?

    init(settings: Settings, delegate: SettingsViewDelegate? = nil) {

        self.settings = settings
        self.delegate = delegate
    }

    var body: some View {

        VStack(alignment: .leading) {
            Form {
                HStack {
                    Text("Host")
                    TextField("http://192.168.X.X", text: $hostname)
                }
                HStack {
                    Spacer()
                    Button("OK", action: submit)
                    Spacer()
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
        .onAppear() {
            hostname = settings.host ?? ""
        }
    }

    func submit() {
        settings.host = hostname
        delegate?.settingsViewDidSubmit(self, with: settings)
    }
}


struct SettingsView_Previews: PreviewProvider {

    static var previews: some View {
        SettingsView(settings: Settings())
            .frame(width: 200, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
