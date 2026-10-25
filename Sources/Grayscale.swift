//
//  Grayscale.swift
//  grayscale
//
//  Created by Brett Gutstein on 1/31/21.
//  Copyright © 2021 Brett Gutstein. All rights reserved.
//

import Darwin

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

func enableGrayscale() {
    MADisplayFilterPrefSetType(SYSTEM_FILTER, GRAYSCALE_TYPE)
    MADisplayFilterPrefSetCategoryEnabled(SYSTEM_FILTER, true)
    wakeUpUniversalAccessD()
    // Also force the display driver to grayscale; on macOS 15+ this is
    // required to affect system UI (Dock, menu bar) which the
    // MediaAccessibility filter no longer covers.
    CGDisplayForceToGray(true)
}

func disableGrayscale() {
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
