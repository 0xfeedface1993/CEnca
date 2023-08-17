import Foundation
import CEnca
import Logging

fileprivate let logger = Logger(label: "com.enca.wrapper")

public enum EncodingWrapperError: Error {
    case analyserAllocFailed
    case memoryBoundUnsafePointerUInt8Failed
    case unkownCharsetName(encoding: Int32)
}

public struct EncodingWrapper {
    public let data: Data
    
    public init(_ data: Data) {
        self.data = data
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func encodingString() async throws -> String {
        let analyser = try analyserAlloctor()
        let buffer = try UnsafeMemory(data).unsafePointerUInt8()
        let encoding = enca_analyse_const(analyser, buffer, data.count)
        let charsetName = try charset(encoding, style: ENCA_NAME_STYLE_ENCA)
        defer {
            enca_analyser_free(analyser)
            logger.info("detect encoding charset: \(charsetName)")
        }
        return charsetName
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func encoding() async throws -> String.Encoding {
        let name = try await encodingString()
        return EncodingMapper(name).paltformEncoding()
    }
    
    @usableFromInline
    func analyserAlloctor() throws -> EncaAnalyser {
        // None
        let language = "__"
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
    
    @usableFromInline
    func charset(_ encoding: EncaEncoding, style: EncaNameStyle) throws -> String {
        guard let charsetCString = enca_charset_name(encoding.charset, style) else {
            throw EncodingWrapperError.unkownCharsetName(encoding: encoding.charset)
        }
        return String(cString: charsetCString)
    }
}

struct EncodingMapper {
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    func paltformEncoding() -> String.Encoding {
        switch name {
        case "ASCII":
            return .ascii
        case "ISO-8859-2":
            return .isoLatin2
        case "ISO-8859-4":
            return CFStringEncodings.isoLatin4.mappingEncoding
        case "ISO-8859-5":
            return CFStringEncodings.isoLatin5.mappingEncoding
        case "ISO-8859-13":
            return CFStringEncodings.isoLatin7.mappingEncoding
        case "ISO-8859-16":
            return CFStringEncodings.isoLatin10.mappingEncoding
//        enca:CP1125
//        rfc:CP1125
//        cstocs:
//        iconv:@ICONV_NAME_CP1125@
//        mime:windows-1125
//        aliases:CP1125 1125 MS-1125 Win-1125 Windows-1125
//        human:MS-Windows code page 1125
//        flags:ENCA_CHARSET_8BIT | ENCA_CHARSET_FIXED | ENCA_CHARSET_REGULAR
//        nsurface:ENCA_SURFACE_EOL_CRLF
            // OOPS
        case "CP1125":
            return .windowsCP1250
        case "CP1250":
            return .windowsCP1250
        case "CP1251":
            return .windowsCP1251
        case "CP1257":
            return CFStringEncodings.windowsBalticRim.mappingEncoding
        case "IBM852":
            return CFStringEncodings.dosLatin2.mappingEncoding
        case "IBM855":
            return CFStringEncodings.dosCyrillic.mappingEncoding
        case "IBM775":
            return CFStringEncodings.dosBalticRim.mappingEncoding
        case "IBM866":
            return CFStringEncodings.dosRussian.mappingEncoding
        case "macce":
            return CFStringEncodings.macCentralEurRoman.mappingEncoding
        case "maccyr":
            return CFStringEncodings.macCyrillic.mappingEncoding
        case "ECMA-113":
            return CFStringEncodings.macCyrillic.mappingEncoding
        case "KOI8-U":
            return CFStringEncodings.KOI8_U.mappingEncoding
        case "UCS-2":
            return .unicode
        case "UCS-4":
            return .unicode
        case "UTF-7":
            return CFStringEncodings.UTF7.mappingEncoding
        case "UTF-8":
            return .utf8
        case "GBK":
            return CFStringEncodings.GB_2312_80.mappingEncoding
        case "BIG5":
            return CFStringEncodings.big5.mappingEncoding
        case "HZ":
            return CFStringEncodings.HZ_GB_2312.mappingEncoding
            //        enca:baltic
            //        rfc:iso-ir-179
            //        cstocs:
            //        iconv:@ICONV_NAME_BALTIC@
            //        mime:
            //        aliases:ISO-IR-179 baltic
            //        human:ISO-IR-179; Baltic
            //        flags:ENCA_CHARSET_8BIT | ENCA_CHARSET_FIXED | ENCA_CHARSET_REGULAR
            //        nsurface:ENCA_SURFACE_EOL_LF
            // OOPS
        case "baltic":
            return CFStringEncodings.windowsBalticRim.mappingEncoding
            //        enca:KEYBCS2
            //        rfc:KEYBCS2
            //        cstocs:kam
            //        iconv:@ICONV_NAME_KEYBCS2@
            //        mime:
            //        aliases:KEYBCS2 Kamenicky kam 895 CP895 PC895 csPC895
            //        human:Kamenicky encoding; KEYBCS2
            //        flags:ENCA_CHARSET_8BIT | ENCA_CHARSET_FIXED | ENCA_CHARSET_REGULAR
            //        nsurface:ENCA_SURFACE_EOL_CRLF
            // OOPS
        case "KEYBCS2":
            return .utf8
            //
            //        enca:KOI-8_CS_2
            //        rfc:KOI-8_CS_2
            //        cstocs:koi8
            //        iconv:@ICONV_NAME_KOI8CS2@
            //        mime:KOI8-CS2
            //        aliases:KOI-8_CS2 koi8cs koi8cz T602
            //        human:KOI8-CS2 code (`T602')
            //        flags:ENCA_CHARSET_8BIT | ENCA_CHARSET_FIXED | ENCA_CHARSET_REGULAR
            //        nsurface:ENCA_SURFACE_EOL_CRLF
            // OOPS
        case "KOI-8_CS_2":
            return CFStringEncodings.KOI8_R.mappingEncoding
            //        enca:KOI8-UNI
            //        rfc:KOI8-UNI
            //        cstocs:
            //        iconv:@ICONV_NAME_KOI8UNI@
            //        mime:
            //        aliases:KOI8-UNI
            //        human:KOI8-Unified Cyrillic
            //        flags:ENCA_CHARSET_8BIT | ENCA_CHARSET_FIXED | ENCA_CHARSET_REGULAR
            //        nsurface:ENCA_SURFACE_EOL_CRLF
        case "KOI8-UNI":
            return CFStringEncodings.KOI8_U.mappingEncoding
            //        enca:TeX
            //        rfc:LaTeX
            //        cstocs: tex
            //        iconv:@ICONV_NAME_LATEX@
            //        mime:
            //        aliases:TeX latex ltex
            //        human:(La)TeX control sequences
            //        flags:ENCA_CHARSET_7BIT | ENCA_CHARSET_VARIABLE | ENCA_CHARSET_MULTIBYTE
            //        nsurface:ENCA_SURFACE_EOL_LF
        case "TeX":
            return CFStringEncodings.UTF7.mappingEncoding
            //        enca:CORK
            //        rfc:CORK
            //        cstocs:
            //        iconv:@ICONV_NAME_CORK@
            //        mime:
            //        aliases:Cork T1
            //        human:Cork encoding; T1
            //        flags:ENCA_CHARSET_8BIT | ENCA_CHARSET_FIXED | ENCA_CHARSET_REGULAR
            //        nsurface:
            // OOPS
        case "CORK":
            return .utf8
        default:
            return .utf8
        }
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

extension CFStringEncodings {
    /// 生成CFString编码对应的String.Encoding
    public var mappingEncoding: String.Encoding {
        .init(rawValue: UInt(rawValue))
    }
}
