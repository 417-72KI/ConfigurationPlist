//
// This is a generated file, do not edit!
// Generated by ConfigurationPlist, see https://github.com/417-72KI/ConfigurationPlist
//

import Foundation

struct AppConfig: Codable {
    static let `default`: AppConfig = .load()
}

private extension AppConfig {
    static func load() -> AppConfig {
        guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist") else { fatalError("Config.plist not found") }
        return load(from: filePath)
    }
}

extension AppConfig {
    static func load(from filePath: String) -> AppConfig {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            return try PropertyListDecoder().decode(AppConfig.self, from: data)
        } catch {
            fatalError("\(filePath) is invalid. cause: \(error)")
        }
    }
}
