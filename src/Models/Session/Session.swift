import Foundation

/// Represents a conversation session with its configuration
public struct Session: Codable, Equatable, Sendable {
    public enum Modality: String, Codable, Sendable {
        case text
        case audio
    }

    public enum Voice: String, Codable, Sendable {
        case alloy
        case echo
        case fable
        case onyx
        case nova
        case shimmer
    }

    /// The unique ID of the session.
    public var id: String?
    /// The default model used for this session.
    public var model: String
    /// The set of modalities the model can respond with.
    public var modalities: [Modality]
    /// The default system instructions.
    public var instructions: String
    /// The voice the model uses to respond.
    public var voice: Voice
    /// The format of input audio.
    public var inputAudioFormat: AudioFormat
    /// The format of output audio.
    public var outputAudioFormat: AudioFormat
    /// Configuration for input audio transcription.
    public var inputAudioTranscription: InputAudioTranscription?
    /// Configuration for turn detection.
    public var turnDetection: TurnDetection?
    /// Tools (functions) available to the model.
    public var tools: [Tool]
    /// How the model chooses tools.
    public var toolChoice: ToolChoice
    /// Sampling temperature.
    public var temperature: Double
    /// Maximum number of output tokens.
    public var maxOutputTokens: Int?

    public init(
        id: String? = nil,
        model: String,
        tools: [Tool] = [],
        instructions: String,
        voice: Voice = .alloy,
        temperature: Double = 1,
        maxOutputTokens: Int? = nil,
        toolChoice: ToolChoice = .auto,
        turnDetection: TurnDetection? = nil,
        inputAudioFormat: AudioFormat = .pcm16,
        outputAudioFormat: AudioFormat = .pcm16,
        modalities: [Modality] = [.text, .audio],
        inputAudioTranscription: InputAudioTranscription? = nil
    ) {
        self.id = id
        self.model = model
        self.tools = tools
        self.voice = voice
        self.toolChoice = toolChoice
        self.modalities = modalities
        self.temperature = temperature
        self.instructions = instructions
        self.turnDetection = turnDetection
        self.maxOutputTokens = maxOutputTokens
        self.inputAudioFormat = inputAudioFormat
        self.outputAudioFormat = outputAudioFormat
        self.inputAudioTranscription = inputAudioTranscription
    }
}
