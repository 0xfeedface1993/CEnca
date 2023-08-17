# EncodingWrapper

The `EncodingWrapper` module provides a Swift wrapper around the `enca` library, allowing you to easily detect the encoding of a given data payload (string data). This module abstracts the low-level interactions with the `enca` library and offers a more user-friendly API for encoding detection.

## Features

- Detect the encoding of a `Data` payload using the `enca` library.
- Translate the detected encoding name to a `String.Encoding` value. (**Testing now**)

## Requirements

- macOS 10.15 or later

## Installation

This module doesn't require any additional dependencies other than the `enca` library. Make sure that the `enca` library is properly installed and accessible in your project.

## Usage

### Initializing `EncodingWrapper`

To use the `EncodingWrapper`, you need to create an instance by passing a `Data` object that you want to analyze:

```swift
import EncodingWrapper

let data = Data(...) // Replace with your data
let encodingWrapper = EncodingWrapper(data)
```

### Detecting Encoding as String

You can asynchronously detect the encoding of the data as a string using the `encodingString()` method:

```swift
do {
    let encodingName = try await encodingWrapper.encodingString()
    print("Detected encoding name: \(encodingName)")
} catch {
    print("Encoding detection failed: \(error)")
}
```

### Detecting Encoding as String.Encoding (Not reliable)

To detect the encoding and get it as a `String.Encoding` value, you can use the `encoding()` method:

```swift
do {
    let detectedEncoding = try await encodingWrapper.encoding()
    print("Detected encoding: \(detectedEncoding)")
} catch {
    print("Encoding detection failed: \(error)")
}
```

### Error Handling

The module provides a custom `EncodingWrapperError` enum for error handling. It includes cases such as `analyserAllocFailed` and `unknownCharsetName`.

### Logging

The module utilizes the Swift `Logging` framework for logging. You can customize the logging behavior by configuring your logger instance.

## Contribution

Contributions to the `EncodingWrapper` module are welcome. Feel free to open issues, submit pull requests, or provide feedback to improve the functionality and usability of the module.

## License

This module is released under the [MIT License](LICENSE). Make sure to review the license terms before using this module in your project.
