import Foundation

/// Represents audio data and its optional transcript
public struct Audio: Equatable, Sendable {
    /// Base64-encoded audio bytes.
    public var audio: Data
    /// The transcript of the audio.
    public var transcript: String?

    public init(audio: Data = Data(), transcript: String? = nil) {
        self.audio = audio
        self.transcript = transcript
    }
}

/// Represents the format of audio data
public enum AudioFormat: String, Codable, Sendable {
    case pcm16
    case g711_ulaw
    case g711_alaw
}

// MARK: - Codable Implementation

extension Audio: Decodable {
    private enum CodingKeys: String, CodingKey {
        case audio
        case transcript
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transcript = try container.decodeIfPresent(String.self, forKey: .transcript)
        let encodedAudio = try container.decodeIfPresent(String.self, forKey: .audio)

        if let encodedAudio {
            guard let decodedAudio = Data(base64Encoded: encodedAudio) else {
                throw DecodingError.dataCorruptedError(forKey: .audio, in: container, debugDescription: "Invalid base64-encoded audio data.")
            }
            audio = decodedAudio
        } else {
            audio = Data()
        }
    }
}
