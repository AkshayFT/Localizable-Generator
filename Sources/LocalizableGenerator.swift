//
//  LocalizableGenerator.swift
//  GenerateLocalizables
//
//  Created by Jose Escabias on 24/10/21.
//  Copyright © 2021 Jose Escabias. All rights reserved.
//

import Foundation
import Files
protocol LocalizableGenerator {
    static func createFile(for language: String, with localizables: [Localizable], destination: String, sourceURL: URL) throws
}

class LocalizableGenerator_iOS: LocalizableGenerator {
    public static func createFile(for language: String, with localizables: [Localizable], destination: String, sourceURL: URL) throws {
        var localizabeText = ""
        localizables.forEach { localizable in
            if !localizable.key.isEmpty {
                let hasSlash = localizable.key.contains { char in
                    return char == "/"
                }
                if hasSlash {
                    localizabeText = localizabeText + localizable.key
                } else {
                    localizabeText = localizabeText + "\n" + "\"\(localizable.key)\"" + " = " + "\"\(localizable.value)\";"
                }
            }
        }
        localizabeText += "\n// End of the generated file \n// Modification of this file by hand is strictly prohibited. \n// Please modify at: \(sourceURL.deletingLastPathComponent().absoluteString).\n"
        let timeString = Date().formatted(date: .long, time: .shortened)
        localizabeText += "// Last Synced by \(NSFullUserName()) on \(timeString)\n"

        do {
            let folder = Folder.current
            var file: File
            let subFolder = try folder.createSubfolderIfNeeded(at: destination)
            let languageFolder = try subFolder.createSubfolder(named: "\(language).lproj")
            try languageFolder.createFile(named: "Localizable.strings")
            file = try languageFolder.file(named: "Localizable.strings")
            try file.write(localizabeText)
            print("✅ Created \(languageFolder.path)".green)
        } catch  {
            print("❌ ERROR CREATING THE LOCALIZABLE STRING FILE ❌".red)
            exit(EXIT_FAILURE)
        }
    }
}

class LocalizableGenerator_Android: LocalizableGenerator {
    static func createFile(for language: String, with localizables: [Localizable], destination: String, sourceURL: URL) throws  {
        var localizabeText = """
        <?xml version="1.0" encoding="utf-8"?>
        <resources xmlns:tools="http://schemas.android.com/tools" tools:ignore="MissingTranslation">
        """

        localizables.forEach { localizable in
            if localizable.key.isEmpty {
                localizabeText = localizabeText + "\n"
            } else  {
                let hasSlash = localizable.key.contains { char in
                    return char == "/"
                }
                if hasSlash {
                    localizabeText = localizabeText + localizable.key
                } else {
                    localizabeText += "\n" + "<string name=\"\(localizable.key)\">\(localizable.value)</string>"
                }
            }
        }
        localizabeText += "\n</resources>\n"

        do {
            let folder = Folder.current
            var file: File
            let subFolder = try folder.createSubfolderIfNeeded(at: destination)
            let languageFolder = try subFolder.createSubfolder(named: language)
            try languageFolder.createFile(named: "strings.xml")
            file = try languageFolder.file(named: "strings.xml")
            try file.write(localizabeText)
            print("✅ Created \(languageFolder.path)".green)
        } catch  {
            print("❌ ERROR CREATING THE LOCALIZABLE STRING FILE ❌".red)
            exit(EXIT_FAILURE)
        }
    }
}
