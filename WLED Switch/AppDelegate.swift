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

        let host: String? = prepareService(with: settings.host) ? settings.host : nil

        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.image = NSImage(named: "Icon")
        statusBarMenu = NSMenu(title: "The Title")
        statusBarItem.menu = statusBarMenu
        setupItems(for: settings.states, host: host, on: statusBarMenu)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private func setupItems(for states: [LEDStatus], host: String?, on menu: NSMenu) {

        menu.removeAllItems()

        for status in states {
            let menuItem = NSMenuItem(title: status.title, action: #selector(Self.menuItemSelected), keyEquivalent: "")
            menuItem.tag = status.id
            menu.addItem(menuItem)
        }
        menu.addItem(NSMenuItem.separator())
        if let host = host {
            let infoItem = NSMenuItem(title: "Host: \(host)", action: nil, keyEquivalent: "")
            infoItem.isEnabled = false
            menu.addItem(infoItem)
        }
        menu.addItem(withTitle: "Settings", action: #selector(Self.settingsItemSelected), keyEquivalent: "")
        menu.addItem(withTitle: "Close", action: #selector(Self.closeItemSelected), keyEquivalent: "")

    }

    @discardableResult
    private func prepareService(with host: String?) -> Bool {

        guard let host = host, host.count > 4 else {
            return false
        }
        self.service = WLEDService(host: host)
        return true
    }

    private func showSettingsWindow() {

        NSApp.activate(ignoringOtherApps: true)

        guard window == nil else {
            window?.makeKeyAndOrderFront(nil)
            return
        }

        let viewModel = SettingsViewModel(
            host: settings.host ?? "",
            states: settings.states
        )
        let settingsView = SettingsView(viewModel: viewModel, delegate: self)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Settings Window")
        window.contentView = NSHostingView(rootView: settingsView)
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
    func settingsViewDidSubmit(_ view: SettingsView, host: String, states: [LEDStatus]) {

        window?.close()
        window = nil

        settings.host = host
        settings.states = states

        let host: String? = prepareService(with: host) ? host : nil
        setupItems(for: states, host: host, on: statusBarMenu)
    }
}

