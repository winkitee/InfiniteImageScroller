//
//  CADisplayLinkManager.swift
//  InfiniteImageScroller
//
//  Created by winkitee on 12/18/24.
//

import UIKit

/// Manages a CADisplayLink for periodic updates.
class CADisplayLinkManager {
    private var displayLink: CADisplayLink? // The CADisplayLink instance.
    private var lastTimestamp: CFTimeInterval = 0 // Tracks the last frame timestamp.
    private var updateHandler: ((Double) -> Void)? // Closure to handle updates with delta time.

    /// Starts the display link with the given update handler.
    func start(updateHandler: @escaping (Double) -> Void) {
        stop() // Ensures any existing display link is stopped.
        self.updateHandler = updateHandler
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .default)
    }

    /// Stops and invalidates the display link.
    func stop() {
        displayLink?.invalidate() // Invalidates the current display link.
        displayLink = nil
        updateHandler = nil
        lastTimestamp = 0 // Resets the timestamp for clean start.
    }

    /// Called by CADisplayLink to provide frame updates.
    @objc private func update(_ displayLink: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = displayLink.timestamp // Sets the initial timestamp.
        }

        let deltaTime = displayLink.timestamp - lastTimestamp // Calculates time difference.
        lastTimestamp = displayLink.timestamp

        updateHandler?(deltaTime) // Executes the update handler with delta time.
    }
}
