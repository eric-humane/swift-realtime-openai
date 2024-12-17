import Foundation

/// Represents a function call in a conversation
public struct FunctionCall: Codable, Equatable, Sendable {
    /// The unique ID of the item.
    public var id: String
    /// The type of the item
    private var type: String = "function_call"
    /// The status of the item
    public var status: ItemStatus
    /// The ID of the function call
    public var callId: String
    /// The name of the function being called
    public var name: String
    /// The arguments of the function call
    public var arguments: String
}

/// Represents the output of a function call
public struct FunctionCallOutput: Codable, Equatable, Sendable {
    /// The unique ID of the item.
    public var id: String
    /// The type of the item
    private var type: String = "function_call_output"
    /// The ID of the function call
    public var callId: String
    /// The output of the function call
    public var output: String

    public init(id: String, callId: String, output: String) {
        self.id = id
        self.callId = callId
        self.output = output
    }
}
