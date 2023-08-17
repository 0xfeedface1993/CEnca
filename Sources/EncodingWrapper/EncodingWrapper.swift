import Foundation
import CEnca
import Logging

fileprivate let logger = Logger(label: "com.enca.wrapper")

public enum EncodingWrapperError: Error {
    case analyserAllocFailed
    case memoryBoundUnsafePointerUInt8Failed
    case unkownCharsetName(encoding: Int32)
}

public struct EncodingEncaError: Error, LocalizedError {
    public let code: Int
    public let message: String
    
    public var errorDescription: String? {
        message
    }
}

public struct EncodingWrapper {
    public let data: Data
    public let style: NameStyle
    
    /// Initializes an `EncodingWrapper` with the provided data.
    /// - Parameter data: The data to be analyzed for encoding detection.
    public init(_ data: Data, style: NameStyle = .enca) {
        self.data = data
        self.style = .enca
    }
    
    public func style(_ value: NameStyle) -> Self {
        .init(data, style: value)
    }
    
    func error(on analyser: EncaAnalyser) throws {
        let code = enca_errno(analyser)
        switch code {
        case Int32(ENCA_EOK.rawValue):
            break
        default:
            guard let message = enca_strerror(analyser, code) else {
                throw EncodingEncaError(code: Int(code), message: "Unknown Error.")
            }
            throw EncodingEncaError(code: Int(code), message: String(cString: message))
        }
    }
    
    /// Detects the encoding of the wrapped data and returns the encoding name as an asynchronous operation.
    /// - Returns: An asynchronous operation that resolves to the detected encoding name.
    public func encodingString() throws -> String {
        let analyser = try analyserAlloctor()
        let buffer = try UnsafeMemory(data).unsafePointerUInt8()
        let encoding = enca_analyse_const(analyser, buffer, data.count)
        try error(on: analyser)
        let charsetName = try charset(encoding, style: style.encaNameStyle)
        defer {
            enca_analyser_free(analyser)
            logger.info("detect encoding charset: [\(charsetName)]")
        }
        return charsetName
    }
    
    /// Detects the encoding of the wrapped data and returns the encoding name as an asynchronous operation.
    /// - Returns: An asynchronous operation that resolves to the detected encoding name.
    @available(macOS 10.15.0, *)
    public func encodingString() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let string = try encodingString()
                continuation.resume(returning: string)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    /// Detects the encoding of the wrapped data and returns the encoding as an asynchronous operation.
    /// - Returns: An asynchronous operation that resolves to the detected `String.Encoding`.
    public func encoding() throws -> String.Encoding {
        let name = try encodingString()
        return EncodingMapper(name).paltformEncoding()
    }
    
    /// Detects the encoding of the wrapped data and returns the encoding as an asynchronous operation.
    /// - Returns: An asynchronous operation that resolves to the detected `String.Encoding`.
    @available(macOS 10.15.0, *)
    public func encoding() async throws -> String.Encoding {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let value = try encoding()
                continuation.resume(returning: value)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    /// Allocates an enca analyser for encoding detection.
       /// - Returns: An enca analyser instance.
    @usableFromInline
    func analyserAlloctor() throws -> EncaAnalyser {
        // None
        let language = "zh"
        var none = language.cString(using: .ascii)!
        let analyser = enca_analyser_alloc(&none)
        guard let analyser = analyser else {
            logger.error("enca_analyser_alloc(\"\(language)\") failed.")
            throw EncodingWrapperError.analyserAllocFailed
        }
        defer {
            none = []
        }
        return analyser
    }
    
    /// Retrieves the charset name for a given encoding and style.
    /// - Parameters:
    ///   - encoding: The encoding for which the charset name is to be retrieved.
    ///   - style: The style in which the charset name should be returned.
    /// - Returns: The charset name as a String.
    @usableFromInline
    func charset(_ encoding: EncaEncoding, style: EncaNameStyle) throws -> String {
        guard let charsetCString = enca_charset_name(encoding.charset, style) else {
            throw EncodingWrapperError.unkownCharsetName(encoding: encoding.charset)
        }
        if String(cString: charsetCString) == "unknown" {
            throw EncodingWrapperError.unkownCharsetName(encoding: encoding.charset)
        }
        return String(cString: charsetCString)
    }
}


struct UnsafeMemory {
    let data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    @usableFromInline
    func unsafePointerUInt8() throws -> UnsafePointer<UInt8>? {
        let buffer = data.withUnsafeBytes {
            $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
        }
        
        guard let buffer = buffer else {
            logger.error("raw data UnsafeRawBufferPointer -> UnsafePointer<UInt8> failed.")
            throw EncodingWrapperError.memoryBoundUnsafePointerUInt8Failed
        }
        
        return buffer
    }
}

extension EncodingWrapper {
    /// Bridge of enca charset naming styles and conventions.
    public enum NameStyle {
        /// Default, implicit charset name in Enca.
        case enca
        /// RFC 1345 or otherwise canonical charset name.
        case rfc1345
        /// Cstocs charset name (may not exist).
        case cstocs
        /// Iconv charset name (may not exist).
        case iconv
        /// Human comprehensible description.
        case human
        /// Preferred MIME name (may not exist).
        case mime
        
        var encaNameStyle: EncaNameStyle {
            switch self {
            case .enca:
                return ENCA_NAME_STYLE_ENCA
            case .rfc1345:
                return ENCA_NAME_STYLE_RFC1345
            case .cstocs:
                return ENCA_NAME_STYLE_CSTOCS
            case .iconv:
                return ENCA_NAME_STYLE_ICONV
            case .human:
                return ENCA_NAME_STYLE_HUMAN
            case .mime:
                return ENCA_NAME_STYLE_MIME
            }
        }
    }
}

extension CFStringEncodings {
    /// Computed property that returns the corresponding String.Encoding for a given CFStringEncodings value.
    public var mappingEncoding: String.Encoding {
        .init(rawValue: UInt(rawValue))
    }
}
