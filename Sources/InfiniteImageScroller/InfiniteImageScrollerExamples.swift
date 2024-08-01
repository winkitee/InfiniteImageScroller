//
//  InfiniteImageScrollerExamples.swift
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

struct InfiniteImageScrollerExamples_Previews: PreviewProvider {

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

    static var previews: some View {
        ExampleView()
    }
}
