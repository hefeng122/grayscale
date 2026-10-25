//
//  Grayscale.swift
//  grayscale
//
//  Created by Brett Gutstein on 1/31/21.
//  Copyright © 2021 Brett Gutstein. All rights reserved.
//

import Darwin
import Foundation

// see Sources/Bridge.h for information about toggling grayscale
func grayscaleEnabled() -> Bool {
    return MADisplayFilterPrefGetCategoryEnabled(SYSTEM_FILTER) &&
        (MADisplayFilterPrefGetType(SYSTEM_FILTER) == GRAYSCALE_TYPE)
}

// Posts the Darwin notification that wakes up universalaccessd.
// On macOS 15+, /usr/lib/libUniversalAccess.dylib no longer exists,
// so _UniversalAccessDStart is unavailable; this replaces it.
func wakeUpUniversalAccessD() {
    let name = CFNotificationName("com.apple.mediaaccessibility.displayFilterSettingsChanged" as CFString)
    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(),
        name,
        nil,
        nil,
        false
    )
}

// macOS 27+ fallback: use Shortcuts app to toggle system-wide grayscale.
// This is the only known way to affect Dock and menu bar on macOS 27.
func runShortcutsGrayscale(enable: Bool) -> Bool {
    let task = Process()
    task.launchPath = "/usr/bin/shortcuts"
    // Try to run a shortcut named "Toggle Grayscale" or "Grayscale"
    task.arguments = ["run", enable ? "Enable Grayscale" : "Disable Grayscale"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    do {
        try task.run()
        task.waitUntilExit()
        return task.terminationStatus == 0
    } catch {
        return false
    }
}

func enableGrayscale() {
    // On macOS 27+, try Shortcuts first for system-wide coverage
    if #available(macOS 27.0, *) {
        if runShortcutsGrayscale(enable: true) {
            return
        }
    }
    
    MADisplayFilterPrefSetType(SYSTEM_FILTER, GRAYSCALE_TYPE)
    MADisplayFilterPrefSetCategoryEnabled(SYSTEM_FILTER, true)
    wakeUpUniversalAccessD()
    // Also force the display driver to grayscale; on macOS 15+ this is
    // required to affect system UI (Dock, menu bar) which the
    // MediaAccessibility filter no longer covers.
    CGDisplayForceToGray(true)
}

func disableGrayscale() {
    // On macOS 27+, try Shortcuts first for system-wide coverage
    if #available(macOS 27.0, *) {
        if runShortcutsGrayscale(enable: false) {
            return
        }
    }
    
    MADisplayFilterPrefSetCategoryEnabled(SYSTEM_FILTER, false)
    wakeUpUniversalAccessD()
    // Revert the display driver grayscale alongside the filter.
    CGDisplayForceToGray(false)
}

func toggleGrayscale() {
    grayscaleEnabled() ? disableGrayscale() : enableGrayscale()
}

func setGrayscale(_ enable: Bool) {
    if grayscaleEnabled() != enable {
        toggleGrayscale()
    }
}
