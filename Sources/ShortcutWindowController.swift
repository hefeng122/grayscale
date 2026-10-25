//
//  ShortcutWindowController.swift
//  grayscale
//
//  Created by Brett Gutstein on 6/11/20.
//  Copyright © 2020 Brett Gutstein. All rights reserved.
//

import Cocoa

class ShortcutWindowController: NSWindowController {

    @IBOutlet weak var shortcutView: MASShortcutView!

    override func windowDidLoad() {
        super.windowDidLoad()

        // recording a shortcut in the view writes it to this user defaults key;
        // the MASShortcutBinder set up in AppDelegate observes the key and keeps
        // the global hotkey registration in sync, so this controller doesn't
        // need to register shortcuts directly
        self.shortcutView.associatedUserDefaultsKey = grayscaleShortcutName
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)

        NSApp.activate(ignoringOtherApps: true)

        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
    }

    override var windowNibName : String! {
      return "ShortcutWindow"
    }

}
