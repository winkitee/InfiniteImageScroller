# InfiniteImageScroller

SwiftUI component for infinitely scrolling images horizontally with customizable labels and directions. Compatible with iOS 13.0 and later.

![InfiniteImageScroller Example](https://winkitee.github.io/InfiniteImageScroller/example_10.gif)

## Installation

To install `InfiniteImageScroller` using Swift Package Manager, add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/winkitee/InfiniteImageScroller.git", from: "0.0.4")
]
```

## Usage

Here are some examples of how to use InfiniteImageScroller in your SwiftUI project:

```swift
import SwiftUI

struct ExampleView: View {
    @State private var isLoading: Bool = true
    @State private var images: [Image] = []

    let colors: [Color] = [.red, .green, .blue]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if images.count > 0 {
                    // First InfiniteImageScroller example
                    InfiniteImageScroller(images) { (_, image) in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    }

                    // Second InfiniteImageScroller example with different configuration
                    InfiniteImageScroller(
                        images,
                        item: .init(.fixed(200), spacing: 16),
                        direction: .right
                    ) { (_, image) in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(20)
                            .background(Circle().fill(.black))
                    }

                    // Third InfiniteImageScroller example with custom speed and background color
                    InfiniteImageScroller(
                        images,
                        item: .init(.fixed(400), spacing: 24),
                        speed: 0.5,
                        direction: .right
                    ) { (index, image) in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .padding(20)
                            .background(RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(colors[index % colors.count]))
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        .onAppear {
            Task {
                await fetchImages()
            }
        }
    }

    @MainActor
    private func fetchImages() async {
        isLoading = true
        defer {
            isLoading = false
        }

        let urls = [
            "https://picsum.photos/400",
            "https://picsum.photos/400",
            "https://picsum.photos/400",
            "https://picsum.photos/400",
            "https://picsum.photos/400",
            "https://picsum.photos/400",
            "https://picsum.photos/400",
            "https://picsum.photos/400",
        ]

        do {
            var images = [Image]()
            try await withThrowingTaskGroup(of: (String, Data).self) { group in
                for url in urls {
                    group.addTask {
                        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
                        return (url, data)
                    }
                }

                for try await (url, data) in group {
                    if let uiImage = UIImage(data: data) {
                        images.append(Image(uiImage: uiImage))
                    } else {
                        print("Failed to convert data to UIImage for URL: \(url)")
                    }
                }
            }
            self.images = images
        } catch {
            print(error)
        }
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
```

## Example Explanation

### Infinite Scroller with Rounded Rectangles

```swift
InfiniteImageScroller(images) { (_, image) in
    image
        .resizable()
        .aspectRatio(contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
}
```

This example demonstrates a simple InfiniteImageScroller with images clipped to a rounded rectangle shape.

### Infinite Scroller with Circular Images and Black Background

```swift
InfiniteImageScroller(
    images,
    item: .init(.fixed(200), spacing: 16),
    direction: .right
) { (_, image) in
    image
        .resizable()
        .aspectRatio(contentMode: .fit)
        .clipShape(Circle())
        .padding(20)
        .background(Circle().fill(.black))
}
```
This example shows how to configure the InfiniteImageScroller with a fixed item size, custom spacing, and right scrolling direction. Images are clipped to a circular shape with a background.

### Infinite Scroller with Custom Speed and Colored Background
```swift
InfiniteImageScroller(
    images,
    item: .init(.fixed(400), spacing: 24),
    speed: 0.5,
    direction: .right
) { (index, image) in
    image
        .resizable()
        .aspectRatio(contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(colors[index % colors.count]))
}
```
