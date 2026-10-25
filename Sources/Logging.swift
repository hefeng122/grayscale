//
//  Logging.swift
//  grayscale
//
//  Created by Brett Gutstein on 1/31/21.
//  Copyright © 2021 Brett Gutstein. All rights reserved.
//

enum LogLevel: Int {
    case VERBOSE = 0
    case ALWAYS_PRINT
}

let currentLogLevel: LogLevel = .ALWAYS_PRINT

func grayscaleLog(logLevel: LogLevel = .ALWAYS_PRINT, _ message: String,
                  file: String = #file, caller: String = #function) {
    if (logLevel.rawValue >= currentLogLevel.rawValue) {
        let fileName = file.components(separatedBy: "/").last ?? ""
        // the message must be passed as an argument rather than spliced into the
        // format string: interpolated values (like application names) may contain
        // % characters, which NSLog would otherwise misinterpret as format
        // specifiers and read nonexistent variadic arguments
        NSLog("%@", "\(fileName):\(caller) \(message)")
    }
}
