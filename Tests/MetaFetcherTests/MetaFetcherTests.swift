import XCTest
@testable import MetaFetcher

final class MetaFetcherTests: XCTestCase {
    func testExample() throws {
        expect { expectation in
            Task {
                let metaFetcher = MetaFetcher()
                let metadata = try? await metaFetcher.fetchFor(url: URL(string: "https://www.avanderlee.com/swift/async-await/")!)
                
                XCTAssertEqual(metadata?.title, "Async await in Swift explained with code examples")
                XCTAssertEqual(metadata?.imageURL?.absoluteString, "https://swiftlee-banners.herokuapp.com/imagegenerator.php?title=Async+await+in+Swift+explained+with+code+examples")
                XCTAssertEqual(metadata?.description, "Async await in Swift allows to write asynchronous tasks with structured concurrency. Maintain readability in complex code.")
                expectation.fulfill()
            }
        }
    }
}

public extension XCTestCase {
    func expect(_ named: String = #function, limitingTo: TimeInterval = 5.0, performing: @escaping ((XCTestExpectation) -> ())) {
        let exp = expectation(description: named)
        performing(exp)
        wait(for: [exp], timeout: limitingTo)
    }
}
