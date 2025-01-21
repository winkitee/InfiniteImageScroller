//
//  ImageScrollerItem.swift
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

/// Represents an item in the image scroller.
public struct ImageScrollerItem: Sendable {

    /// Enumeration for specifying the size of the item.
    public enum Size: Sendable {
        /// A single item with the specified fixed size.
        case fixed(CGFloat)
        
        /// A fixed size that allows specifying individual width and height.
        case fixedSize(CGSize)

        /// Returns the width of the item based on the case.
        var width: CGFloat {
            switch self {
            case .fixed(let width):
                return width
            case .fixedSize(let size):
                return size.width
            }
        }

        /// Returns the height of the item based on the case.
        var height: CGFloat {
            switch self {
            case .fixed(let width):
                return width
            case .fixedSize(let size):
                return size.height
            }
        }
    }

    /// Size of the scroller item.
    public var size: ImageScrollerItem.Size

    /// Spacing between items in the scroller.
    public var spacing: CGFloat

    /// Initializer for ImageScrollerItem.
    /// - Parameters:
    ///   - size: The size of the item. Defaults to `.fixed(120)`.
    ///   - spacing: The spacing between items. Defaults to `12`.
    public init(_ size: ImageScrollerItem.Size = .fixed(120), spacing: CGFloat = 12) {
        self.size = size
        self.spacing = spacing
    }
}
