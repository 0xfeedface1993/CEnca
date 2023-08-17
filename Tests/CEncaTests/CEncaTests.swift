import XCTest
@testable import EncodingWrapper

final class CEncaTests: XCTestCase {
    func testEncoding() async throws {
        let encoding = String.Encoding.utf8
        let data = "你好".data(using: encoding)!
        let next = try await EncodingWrapper(data).encoding()
        XCTAssertEqual(next, encoding)
    }
    
    func testAllEncoding() async throws {
        let encoding = String.Encoding.unicode
        let data = "你好hellowprdzzz.he,l".data(using: encoding)!
        let next = try await EncodingWrapper(data).guessAllLanguageFoEncodingString()
        XCTAssertEqual(next, "UCS-2")
    }
}
