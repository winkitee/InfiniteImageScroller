//
//  InfiniteImageScroller.swift
//
//  Created by winkitee on 8/1/24.
//
//  MIT License
//
//  Copyright (c) 2024 KIM SEUNG YEON (@winkitee)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI

/// A SwiftUI view that scrolls images infinitely in a specified direction.
public struct InfiniteImageScroller<Label>: View where Label: View {

    /// Enumeration for scroll direction.
    public enum ScrollDirection {
        case left
        case right

        /// Offset increment value based on scroll direction.
        var offsetIncrement: CGFloat {
            switch self {
            case .left:
                return -1.0
            case .right:
                return 1.0
            }
        }
    }

    /// Array of images to be displayed in the scroller.
    private let images: [Image]

    /// Item configuration for the scroller.
    private let item: ImageScrollerItem

    /// Direction in which the images should scroll.
    private let direction: ScrollDirection

    /// Speed of the scrolling animation.
    private let speed: CGFloat

    /// Array of labels for each image.
    @State private var labels: [Label] = []

    /// Array of offsets for each label.
    @State private var offsets: [CGFloat] = []

    /// Timer for controlling the scrolling animation.
    @State private var timer: Timer?

    /// ViewBuilder closure to create a label for each image.
    @ViewBuilder private var label: (Int, Image) -> Label

    /// Initializer for InfiniteImageScroller.
    /// - Parameters:
    ///   - images: The images to be displayed.
    ///   - item: Configuration for the scroller item. Defaults to `ImageScrollerItem()`.
    ///   - speed: The speed of the scrolling animation. Defaults to `1.0`.
    ///   - direction: The direction in which the images should scroll. Defaults to `.left`.
    ///   - label: A closure that provides the label for each image.
    public init(_ images: [Image], item: ImageScrollerItem = ImageScrollerItem(), speed: CGFloat = 1.0, direction: ScrollDirection = .left, @ViewBuilder label: @escaping (Int, Image) -> Label) {
        self.images = images
        self.item = item
        self.speed = speed
        self.direction = direction
        self.label = label
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                ForEach(0..<labels.count, id: \.self) { i in
                    labels[i]
                        .frame(width: item.size.width, height: item.size.height)
                        .compositingGroup()
                        .offset(x: offsets[i])
                }
                Color.clear
                    .onAppear {
                        initializeLabels(maxWidth: geometry.size.width)
                        startScrolling(maxWidth: geometry.size.width)
                    }
            }
        }
        .frame(height: item.size.height)
        .clipped()
        .onDisappear {
            stopScrolling()
        }
    }

    /// Initializes labels and their offsets.
    /// - Parameter maxWidth: The maximum width of the container.
    private func initializeLabels(maxWidth: CGFloat) {
        let itemWidth = item.size.width
        let itemSpacing = item.spacing
        let repetitionCount = requiredRepetitionCount(forWidth: maxWidth)

        var newLabels: [Label] = []
        var newOffsets: [CGFloat] = []
        for i in 0..<images.count * repetitionCount {
            newLabels.append(label(i, images[i % images.count]))
            switch direction {
            case .left:
                newOffsets.append(CGFloat(i) * (itemWidth + itemSpacing))
            case .right:
                newOffsets.append(CGFloat(-i) * (itemWidth + itemSpacing) + (maxWidth - itemWidth))
            }
        }
        self.labels = newLabels
        self.offsets = newOffsets
    }

    /// Calculates the required number of repetitions to fill the width.
    /// - Parameter maxWidth: The maximum width of the container.
    /// - Returns: The number of repetitions needed.
    private func requiredRepetitionCount(forWidth maxWidth: CGFloat) -> Int {
        let itemWidth = item.size.width
        let itemSpacing = item.spacing

        var count = 1
        while CGFloat((images.count * count) - 1) * (itemWidth + itemSpacing) < maxWidth {
            count += 1
        }

        return count
    }

    /// Calculates the maximum offset for the given width.
    /// - Parameter maxWidth: The maximum width of the container.
    /// - Returns: The maximum offset value.
    private func maximumOffset(forWidth maxWidth: CGFloat) -> CGFloat {
        let itemWidth = item.size.width
        let itemSpacing = item.spacing
        return CGFloat((images.count * requiredRepetitionCount(forWidth: maxWidth)) - 1) * (itemWidth + itemSpacing)
    }

    /// Starts the scrolling animation.
    /// - Parameter maxWidth: The maximum width of the container.
    @MainActor
    private func startScrolling(maxWidth: CGFloat) {
        let itemWidth = item.size.width
        let itemSpacing = item.spacing
        let lastOffset = maximumOffset(forWidth: maxWidth)

        stopScrolling()

        let leftScrollResetOffset = (itemWidth + itemSpacing) * -1
        let rightScrollResetOffset = lastOffset * -1 + (maxWidth - itemWidth) - itemSpacing

        let interval: Double = 1 / 60
        let animationDuration: Double = interval * 2
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            for i in 0..<offsets.count {
                withAnimation(.linear(duration: animationDuration)) {
                    offsets[i] += direction.offsetIncrement * speed
                }

                if direction == .left && offsets[i] <= leftScrollResetOffset {
                    offsets[i] = lastOffset
                } else if direction == .right && offsets[i] >= maxWidth {
                    offsets[i] = rightScrollResetOffset
                }
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }

    /// Stops the scrolling animation.
    private func stopScrolling() {
        timer?.invalidate()
        timer = nil
    }
}
