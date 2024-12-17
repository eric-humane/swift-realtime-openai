import Foundation


/// Represents an item in a conversation, which can be a message, function call, or function call output
public enum Item: Identifiable, Equatable, Sendable {
    public enum ItemStatus: String, Codable, Sendable {
        case completed
        case in_progress
        case incomplete
    }

    public enum ItemRole: String, Codable, Sendable {
        case user
        case system
        case assistant
    }

    case message(Message)
    case functionCall(FunctionCall)
    case functionCallOutput(FunctionCallOutput)

    public var id: String {
        switch self {
            case let .message(message):
                return message.id
            case let .functionCall(functionCall):
                return functionCall.id
            case let .functionCallOutput(functionCallOutput):
                return functionCallOutput.id
        }
    }

    public init(message: Message) {
        self = .message(message)
    }

    public init(calling functionCall: FunctionCall) {
        self = .functionCall(functionCall)
    }

    public init(with functionCallOutput: FunctionCallOutput) {
        self = .functionCallOutput(functionCallOutput)
    }
}

// MARK: - Codable Implementation

extension Item: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
            case "message":
                self = try .message(Message(from: decoder))
            case "function_call":
                self = try .functionCall(FunctionCall(from: decoder))
            case "function_call_output":
                self = try .functionCallOutput(FunctionCallOutput(from: decoder))
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown item type: \(type)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
            case let .message(message):
                try message.encode(to: encoder)
            case let .functionCall(functionCall):
                try functionCall.encode(to: encoder)
            case let .functionCallOutput(functionCallOutput):
                try functionCallOutput.encode(to: encoder)
        }
    }
}
