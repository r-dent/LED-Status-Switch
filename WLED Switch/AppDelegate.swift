//
//  AppDelegate.swift
//  WLED Switch
//
//  Created by Roman Gille on 25.01.21.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    weak var window: NSWindow?

    var statusBarItem: NSStatusItem!
    var statusBarMenu: NSMenu!

    private let settings = Settings()
    private var service: WLEDService?

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        prepareService(settings: settings)

        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.image = NSImage(named: "Icon")
        statusBarMenu = NSMenu(title: "The Title")
        statusBarItem.menu = statusBarMenu

        for status in LEDStatus.all {
            let menuItem = NSMenuItem(title: status.title, action: #selector(Self.menuItemSelected), keyEquivalent: "")
            menuItem.tag = status.id
            statusBarMenu.addItem(menuItem)
        }
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(withTitle: "Settings", action: #selector(Self.settingsItemSelected), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "Close", action: #selector(Self.closeItemSelected), keyEquivalent: "")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private func prepareService(settings: Settings) {

        guard let host = settings.host, host.count > 4 else {
            return
        }
        self.service = WLEDService(host: host)
    }

    private func showSettingsWindow() {

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Settings Window")
        window.contentView = NSHostingView(rootView: SettingsView(settings: settings, delegate: self))
        window.makeKeyAndOrderFront(nil)

        self.window = window
    }

    @objc func menuItemSelected(_ sender: NSView) {

        guard let status = LEDStatus.all.first(where: { $0.id == sender.tag }) else {
            return
        }
        guard let service = self.service else {
            showSettingsWindow()
            return
        }
        service.setStatus(status)
    }

    @objc func settingsItemSelected(_ sender: NSView) {
        showSettingsWindow()
    }

    @objc func closeItemSelected(_ sender: NSView) {
        NSApplication.shared.terminate(self)
    }
}

extension AppDelegate: SettingsViewDelegate {

    func settingsViewDidSubmit(_ view: SettingsView, with settings: Settings) {
        window?.close()
        prepareService(settings: settings)
    }
}

