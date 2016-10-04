import XCTest
@testable import Aftermath

class ReactionProducerTests: XCTestCase {

  var controller: Controller!

  override func setUp() {
    super.setUp()
    controller = Controller()
  }

  override func tearDown() {
    super.tearDown()
    Engine.sharedInstance.invalidate()
  }

  // MARK: - Tests

  func testReactWithProgress() {
    controller.react(to: AdditionCommand.self, with: controller.reaction)
    XCTAssertEqual((Engine.sharedInstance.eventBus as? EventBus)?.listeners.count, 1)
    XCTAssertEqual(Engine.sharedInstance.reactionDisposer.tokens[Controller.identifier]?.count, 1)

    let event = Event<AdditionCommand>.progress
    Engine.sharedInstance.eventBus.publish(event)

    XCTAssertEqual(controller.state, .progress)
  }

  func testReactWithData() {
    controller.react(to: AdditionCommand.self, with: controller.reaction)
    XCTAssertEqual((Engine.sharedInstance.eventBus as? EventBus)?.listeners.count, 1)
    XCTAssertEqual(Engine.sharedInstance.reactionDisposer.tokens[Controller.identifier]?.count, 1)

    let event = Event<AdditionCommand>.data(Calculator(result: 11))
    Engine.sharedInstance.eventBus.publish(event)

    XCTAssertEqual(controller.state, .data)
  }

  func testReactWithError() {
    controller.react(to: AdditionCommand.self, with: controller.reaction)
    XCTAssertEqual((Engine.sharedInstance.eventBus as? EventBus)?.listeners.count, 1)
    XCTAssertEqual(Engine.sharedInstance.reactionDisposer.tokens[Controller.identifier]?.count, 1)

    let event = Event<AdditionCommand>.Error(TestError.test)
    Engine.sharedInstance.eventBus.publish(event)

    XCTAssertEqual(controller.state, .error)
  }

  func testDispose() {
    let token = controller.react(to: AdditionCommand.self, with: controller.reaction)
    XCTAssertEqual((Engine.sharedInstance.eventBus as? EventBus)?.listeners.count, 1)
    XCTAssertEqual(Engine.sharedInstance.reactionDisposer.tokens[Controller.identifier]?.count, 1)

    controller.dispose(token)
    XCTAssertEqual((Engine.sharedInstance.eventBus as? EventBus)?.listeners.count, 0)
    XCTAssertNil(Engine.sharedInstance.reactionDisposer.tokens[Controller.identifier])
  }

  func testDisposeAll() {
    controller.react(to: AdditionCommand.self, with: controller.reaction)
    XCTAssertEqual((Engine.sharedInstance.eventBus as? EventBus)?.listeners.count, 1)
    XCTAssertEqual(Engine.sharedInstance.reactionDisposer.tokens[Controller.identifier]?.count, 1)

    controller.disposeAll()
    XCTAssertEqual((Engine.sharedInstance.eventBus as? EventBus)?.listeners.count, 0)
    XCTAssertNil(Engine.sharedInstance.reactionDisposer.tokens[Controller.identifier])
  }
}
