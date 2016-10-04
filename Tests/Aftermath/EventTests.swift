import XCTest
@testable import Aftermath

class EventTests: XCTestCase {

  // MARK: - Tests

  func testBuildErrorEvent() {
    let errorEvent = Event<TestCommand>.buildErrorEvent(TestError.test)
    XCTAssertTrue(errorEvent is Event<TestCommand>)
  }

  func testInProgress() {
    let progressEvent = Event<TestCommand>.progress
    XCTAssertTrue(progressEvent.inProgress)

    let dataEvent = Event<TestCommand>.data("Data")
    XCTAssertFalse(dataEvent.inProgress)

    let errorEvent = Event<TestCommand>.Error(TestError.test)
    XCTAssertFalse(errorEvent.inProgress)
  }

  func testResult() {
    let progressEvent = Event<TestCommand>.progress
    XCTAssertNil(progressEvent.result)

    let result = "Data"
    let dataEvent = Event<TestCommand>.data(result)
    XCTAssertEqual(dataEvent.result as? String, result)

    let errorEvent = Event<TestCommand>.Error(TestError.test)
    XCTAssertNil(errorEvent.result)
  }

  func testError() {
    let progressEvent = Event<TestCommand>.progress
    XCTAssertNil(progressEvent.error)

    let dataEvent = Event<TestCommand>.data("Data")
    XCTAssertNil(dataEvent.error)

    let errorEvent = Event<TestCommand>.Error(TestError.test)
    XCTAssertTrue(errorEvent.error is TestError)
  }
}
