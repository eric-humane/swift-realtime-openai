import Foundation

public struct FunctionCall: Codable, Equatable, Sendable {
    public var id: String
    private var type: String = "function_call"
    public var status: ItemStatus
    public var callId: String
    public var name: String
    public var arguments: String
}

public struct FunctionCallOutput: Codable, Equatable, Sendable {
    public var id: String
    private var type: String = "function_call_output"
    public var callId: String
    public var output: String

    public init(id: String, callId: String, output: String) {
        self.id = id
        self.callId = callId
        self.output = output
    }
}
