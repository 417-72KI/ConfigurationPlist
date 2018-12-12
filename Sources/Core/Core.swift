import Foundation
import Common
import Generator
import Parser
import PathKit

public struct Core {
    let outputDirectory: Path
    let environment: String?
    let srcDirectoryPath: Path
    let tempDirectoryPath: Path

    public init(outputDirectory: Path, environment: String?, srcDirectoryPath: Path, tempDirectoryPath: Path) {
        self.outputDirectory = outputDirectory
        self.environment = environment
        self.srcDirectoryPath = srcDirectoryPath
        self.tempDirectoryPath = tempDirectoryPath
    }

    public func execute() throws {
        defer { createLastRunFile() }

        guard srcDirectoryPath.isDirectory else { throw CommonError.notDirectory(srcDirectoryPath) }
        guard outputDirectory.isDirectory else { throw CommonError.notDirectory(outputDirectory) }
        let data = try Parser(directoryPath: srcDirectoryPath).run(environment: environment)
        let outputFile = outputDirectory + Constants.defaultOutputFileName
        try dumpData(data, to: outputFile)

        let generatedSwift = try Generator(data: data).run()
        let outputSwiftFile = outputDirectory + Constants.generatedSwiftFileName
        try dumpSwift(generatedSwift, to: outputSwiftFile)
    }
}

extension Core {
    func dumpData(_ data: Data, to dest: Path) throws {
        precondition(!dest.isDirectory, "\(dest) is directory.")
        try data.write(to: dest.url)
        print("create \(dest)")
    }

    func dumpSwift(_ content: String, to dest: Path) throws {
        let currentContent = try? String(contentsOf: dest.url)
        if currentContent == content {
            print("No change.")
            return
        }
        try content.write(to: dest.url, atomically: true, encoding: .utf8)
        print("create \(dest)")
    }
}

extension Core {
    func createLastRunFile() {
        do {
            let lastRunFile = tempDirectoryPath + Constants.lastRunFileName
            try "\(Date().timeIntervalSince1970)\n"
                .write(to: lastRunFile.url, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to write out to '\(Constants.lastRunFileName)', this might cause Xcode to not run the build phase for ConfigurationPlist: \(error)")
        }
    }
}
