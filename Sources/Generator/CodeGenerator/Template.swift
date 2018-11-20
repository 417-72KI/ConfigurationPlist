enum Template: CaseIterable {
    case header
    case root
    case loadExtension
    case `struct`
}

extension Template {
    var code: String {
        switch self {
        case .header:
            return  """
            //
            // This is a generated file, do not edit!
            // Generated by ConfigurationPlist, see https://github.com/417-72KI/ConfigurationPlist
            //

            import Foundation
            """
        case .root:
            return  """
            struct AppConfig: Codable {
                static let `default`: AppConfig = .load()

                {% for property in properties  %}
                let {{ property.name }}: {{ property.type }}
                {% endfor %}

                enum CodingKeys: String, CodingKey {
                    {% for codingKey in codingKeys %}
                    case {{ codingKey.key }}{% if codingKey.key != codingKey.origin %} = "{{ codingKey.origin }}"{% endif %}
                    {% endfor %}
                }
            }
            """
        case .loadExtension:
            return  """
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
                        fatalError("\\(filePath) is invalid. cause: \\(error)")
                    }
                }
            }
            """
        case .struct:
            return """
            extension {{ parent }} {
                struct {{ name }}: Codable {
                    {% for property in properties  %}
                    let {{ property.name }}: {{ property.type }}
                    {% endfor %}

                    enum CodingKeys: String, CodingKey {
                        {% for codingKey in codingKeys %}
                        case {{ codingKey.key }}{% if codingKey.key != codingKey.origin %} = "{{ codingKey.origin }}"{% endif %}
                        {% endfor %}
                    }
                }
            }
            """
        }
    }
}
