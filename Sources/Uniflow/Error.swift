public protocol ErrorHandler {
  func handleError(error: ErrorType)
}

public enum Error: ErrorType {
  case CommandDispatcherDeallocated
  case EventDispatcherDeallocated
  case InvalidCommandType
}

public enum Warning: ErrorType {
  case NoCommandHandlers(command: AnyCommand)
  case NoEventListeners(event: AnyEvent)
  case DuplicatedCommandHandler(command: AnyCommand.Type, handler: Any)
  case DuplicatedEventListener(event: AnyEvent)
}