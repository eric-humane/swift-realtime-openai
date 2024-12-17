import Foundation

/// Represents a tool (function) that can be used by the model
public struct Tool: Codable, Equatable, Sendable {
    public struct FunctionParameters: Codable, Equatable, Sendable {
        public var type: JSONType
        public var properties: [String: Property]?
        public var required: [String]?
        public var pattern: String?
        public var const: String?
        public var `enum`: [String]?
        public var multipleOf: Int?
        public var minimum: Int?
        public var maximum: Int?

        public init(
            type: JSONType,
            properties: [String: Property]? = nil,
            required: [String]? = nil,
            pattern: String? = nil,
            const: String? = nil,
            enum: [String]? = nil,
            multipleOf: Int? = nil,
            minimum: Int? = nil,
            maximum: Int? = nil
        ) {
            self.type = type
            self.properties = properties
            self.required = required
            self.pattern = pattern
            self.const = const
            self.enum = `enum`
            self.multipleOf = multipleOf
            self.minimum = minimum
            self.maximum = maximum
        }

        public struct Property: Codable, Equatable, Sendable {
            public var type: JSONType
            public var description: String?
            public var format: String?
            public var items: Items?
            public var required: [String]?
            public var pattern: String?
            public var const: String?
            public var `enum`: [String]?
            public var multipleOf: Int?
            public var minimum: Double?
            public var maximum: Double?
            public var minItems: Int?
            public var maxItems: Int?
            public var uniqueItems: Bool?

            public init(
                type: JSONType,
                description: String? = nil,
                format: String? = nil,
                items: Self.Items? = nil,
                required: [String]? = nil,
                pattern: String? = nil,
                const: String? = nil,
                enum: [String]? = nil,
                multipleOf: Int? = nil,
                minimum: Double? = nil,
                maximum: Double? = nil,
                minItems: Int? = nil,
                maxItems: Int? = nil,
                uniqueItems: Bool? = nil
            ) {
                self.type = type
                self.description = description
                self.format = format
                self.items = items
                self.required = required
                self.pattern = pattern
                self.const = const
                self.enum = `enum`
                self.multipleOf = multipleOf
                self.minimum = minimum
                self.maximum = maximum
                self.minItems = minItems
                self.maxItems = maxItems
                self.uniqueItems = uniqueItems
            }

            public struct Items: Codable, Equatable, Sendable {
                public var type: JSONType
                public var properties: [String: Property]?
                public var pattern: String?
                public var const: String?
                public var `enum`: [String]?
                public var multipleOf: Int?
                public var minimum: Double?
                public var maximum: Double?
                public var minItems: Int?
                public var maxItems: Int?
                public var uniqueItems: Bool?

                public init(
                    type: JSONType,
                    properties: [String: Property]? = nil,
                    pattern: String? = nil,
                    const: String? = nil,
                    enum: [String]? = nil,
                    multipleOf: Int? = nil,
                    minimum: Double? = nil,
                    maximum: Double? = nil,
                    minItems: Int? = nil,
                    maxItems: Int? = nil,
                    uniqueItems: Bool? = nil
                ) {
                    self.type = type
                    self.properties = properties
                    self.pattern = pattern
                    self.const = const
                    self.enum = `enum`
                    self.multipleOf = multipleOf
                    self.minimum = minimum
                    self.maximum = maximum
                    self.minItems = minItems
                    self.maxItems = maxItems
                    self.uniqueItems = uniqueItems
                }
            }
        }

        public enum JSONType: String, Codable, Sendable {
            case integer
            case string
            case boolean
            case array
            case object
            case number
            case null
        }
    }

    /// The type of the tool.
    public var type: String
    /// The name of the function.
    public var name: String
    /// The description of the function.
    public var description: String
    /// Parameters of the function in JSON Schema.
    public var parameters: FunctionParameters

    public init(type: String, name: String, description: String, parameters: FunctionParameters) {
        self.type = type
        self.name = name
        self.description = description
        self.parameters = parameters
    }
}

/// Represents how the model chooses tools
public enum ToolChoice: Equatable, Sendable {
    case auto
    case none
    case required
    case function(String)


    public init(function name: String) {
        self = .function(name)
    }
}

// MARK: - Codable Implementation

extension ToolChoice: Codable {
    private enum FunctionCall: Codable {
        case type
        case function

        enum CodingKeys: CodingKey {
            case type
            case function
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let stringValue = try? container.decode(String.self) {
            switch stringValue {
                case "none":
                    self = .none
                case "auto":
                    self = .auto
                case "required":
                    self = .required
                default:
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown tool choice: \(stringValue)")
            }
        } else {
            let container = try decoder.container(keyedBy: FunctionCall.CodingKeys.self)
            let name = try container.decode(String.self, forKey: .function)
            self = .function(name)
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
            case .none:
                var container = encoder.singleValueContainer()
                try container.encode("none")
            case .auto:
                var container = encoder.singleValueContainer()
                try container.encode("auto")
            case .required:
                var container = encoder.singleValueContainer()
                try container.encode("required")
            case let .function(name):
                var container = encoder.container(keyedBy: FunctionCall.CodingKeys.self)
                try container.encode("function", forKey: .type)
                try container.encode(name, forKey: .function)
        }
    }
}
