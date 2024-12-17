import Foundation

/// Represents a message in a conversation
public struct Message: Codable, Equatable, Sendable {
    public enum Content: Equatable, Sendable {
        case text(String)
        case audio(Audio)
        case input_text(String)
        case input_audio(Audio)

        public var text: String? {
            switch self {
                case let .text(text):
                    return text
                case let .input_text(text):
                    return text
                case let .input_audio(audio):
                    return audio.transcript
                case let .audio(audio):
                    return audio.transcript
            }
        }
    }

    /// The unique ID of the item.
    public var id: String
    /// The type of the item
    private var type: String = "message"
    /// The status of the item
    public var status: ItemStatus
    /// The role associated with the item
    public var role: ItemRole
    /// The content of the message.
    public var content: [Content]

    public init(id: String, from role: ItemRole, content: [Content]) {
        self.id = id
        self.role = role
        status = .completed
        self.content = content
    }
}

// MARK: - Codable Implementation

extension Message.Content: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case text
        case audio
        case transcript
    }

    private struct Text: Codable {
        let text: String

        enum CodingKeys: CodingKey {
            case text
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
            case "text":
                let container = try decoder.container(keyedBy: Text.CodingKeys.self)
                self = try .text(container.decode(String.self, forKey: .text))
            case "input_text":
                let container = try decoder.container(keyedBy: Text.CodingKeys.self)
                self = try .input_text(container.decode(String.self, forKey: .text))
            case "audio":
                self = try .audio(Audio(from: decoder))
            case "input_audio":
                self = try .input_audio(Audio(from: decoder))
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown content type: \(type)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
            case let .text(text):
                try container.encode(text, forKey: .text)
                try container.encode("text", forKey: .type)
            case let .input_text(text):
                try container.encode(text, forKey: .text)
                try container.encode("input_text", forKey: .type)
            case let .audio(audio):
                try container.encode("audio", forKey: .type)
                try container.encode(audio.transcript, forKey: .transcript)
                try container.encode(audio.audio.base64EncodedString(), forKey: .audio)
            case let .input_audio(audio):
                try container.encode("input_audio", forKey: .type)
                try container.encode(audio.transcript, forKey: .transcript)
                try container.encode(audio.audio.base64EncodedString(), forKey: .audio)
        }
    }
}
