import Foundation

public struct Environment {
    private init() {}
}

public extension Environment {
    static func getValue(forKey key: Key) throws -> String {
        guard let value = ProcessInfo().environment[key.rawValue] else {
            throw Error.notFound(key)
        }
        return value
    }
}

extension Environment {
    public enum Key {
        case tempDir
        case scriptInputFileCount
        case scriptOutputFileCount
        case scriptInputFile(Int)
        case scriptOutputFile(Int)

        public var rawValue: String {
            switch self {
            case .tempDir: return "TEMP_DIR"
            case .scriptInputFileCount: return "SCRIPT_INPUT_FILE_COUNT"
            case .scriptOutputFileCount: return "SCRIPT_OUTPUT_FILE_COUNT"
            case .scriptInputFile(let num): return "SCRIPT_INPUT_FILE_\(num)"
            case .scriptOutputFile(let num): return "SCRIPT_OUTPUT_FILE_\(num)"
            }
        }
    }
}

extension Environment {
    public enum Error: Swift.Error {
        case notFound(Key)
    }
}

extension Environment.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notFound(let key):
            return "Missing value for `\(key.rawValue)` in environment."
        }
    }
}
