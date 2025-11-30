// Credit to https://github.com/bouk/dark-mode-notify for the base code
// TODO: Refactor this to use a class entrypoint

import Cocoa

@discardableResult
func shell(_ args: [String]) -> Int32 {
    let task = Process()

    let appearance = NSApplication.shared.effectiveAppearance
    let match = appearance.bestMatch(from: [.darkAqua, .aqua])
    let isDark = (match == .darkAqua)


    var env = ProcessInfo.processInfo.environment
    env["DARKMODE"] = isDark ? "1" : "0"
    task.environment = env

    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.standardError = FileHandle.standardError
    task.standardOutput = FileHandle.standardOutput

    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

let args = Array(CommandLine.arguments.suffix(from: 1))

// Run once at startup
shell(args)

// Keep a strong reference so the observation doesn’t get deallocated.
var appearanceObserver: NSKeyValueObservation?

appearanceObserver = NSApplication.shared.observe(
    \.effectiveAppearance,
    options: [.new, .old, .initial, .prior]
) { _, _ in
    shell(args)
}

// (Optional) Still listen for wake if you want a “hard” resync after sleep.
NSWorkspace.shared.notificationCenter.addObserver(
    forName: NSWorkspace.didWakeNotification,
    object: nil,
    queue: nil
) { _ in
    shell(args)
}

NSApplication.shared.run()
