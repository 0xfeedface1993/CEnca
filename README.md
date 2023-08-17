# EncodingWrapper

![Swift5.8+](https://img.shields.io/badge/Swift-5.8%2B-orange.svg?style=flat)
![platforms](https://img.shields.io/badge/Platforms-macOS%20%7C%20Linux-orange.svg?style=flat)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/0xfeedface1993/CEnca/blob/master/LICENSE)  

EncodingWrapper is an open-source Swift library that provides a simplified API for encoding detection using the `enca` library. This library allows you to detect the character encoding of data and work with various encoding-related functionalities in a more straightforward manner.

## Installation

You can integrate EncodingWrapper into your project using Swift Package Manager (SPM). Simply add the following dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/nijel/enca.git", from: "0.1.0"),
```

## Usage

First, import the required modules:

```swift
import CEnca
```

### Initializing EncodingWrapper

The `EncodingWrapper` struct provides a simple way to work with encoding detection. Here's how to initialize it:

```swift
let data = Data(...) // Your data to be analyzed
let wrapper = EncodingWrapper(data)
```

You can also specify a custom `NameStyle` by calling the `style(_:)` method:

```swift
let customStyle: NameStyle = .rfc1345
let wrapperWithCustomStyle = wrapper.style(customStyle)
```

### Detecting Encoding

To detect the encoding of the wrapped data, you can use the `encodingString()` method. This asynchronous method returns the detected encoding name as a result:

```swift
do {
    let detectedEncodingName = try await wrapper.encodingString()
    print("Detected encoding: \(detectedEncodingName)")
} catch {
    print("Error detecting encoding: \(error)")
}
```

You can also use the `encoding()` method to get the detected `String.Encoding`:

```swift
do {
    let detectedEncoding = try await wrapper.encoding()
    print("Detected encoding: \(detectedEncoding)")
} catch {
    print("Error detecting encoding: \(error)")
}
```

### Error Handling

The `EncodingWrapper` API throws errors that you can catch and handle. The `EncodingWrapperError` enum provides error cases:

- `.analyserAllocFailed`: Failed to allocate an enca analyser.
- `.memoryBoundUnsafePointerUInt8Failed`: Failed to bind memory for UnsafePointer<UInt8>.
- `.unkownCharsetName(encoding: Int32)`: Unknown charset name for the given encoding.

### Additional Notes

Please note that EncodingWrapper relies on the enca library for encoding detection. Make sure to link the enca library to your project. You can find the original enca library [enca](https://github.com/nijel/enca.git).

## Contributions

Contributions to this open-source project are welcome! Feel free to submit issues or pull requests on the [GitHub repository](https://github.com/0xfeedface1993/CEnca.git).

## License

EncodingWrapper is available under the MIT license. See the [LICENSE](LICENSE) file for more information.
