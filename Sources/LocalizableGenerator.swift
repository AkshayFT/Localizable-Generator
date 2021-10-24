//
//  LocalizableGenerator.swift
//  GenerateLocalizables
//
//  Created by Jose Escabias on 24/10/21.
//  Copyright © 2021 Jose Escabias. All rights reserved.
//

import Foundation
import Files

class LocalizableGenerator {
    public static func createFile(for language: String, with localizables: [Localizable]) throws {
        var localizabeText = ""
        localizabeText = "// This Localizable file is Autogenerated with a script. Please don´t modify this file by hand \n"

        localizables.forEach { localizable in
            localizabeText = localizabeText + "\n" + "\"\(localizable.key)\"" + " = " + "\"\(localizable.value)\";"
        }
        
        do {
            let folder = Folder.current
            
            try folder.subfolders.recursive.forEach({ aFolder in
                var file: File
                if aFolder.name == "\(language).lproj" {
                    
                    let languageFolder = try Folder(path: aFolder.path)
                    
                    if languageFolder.files.count() == 0 {
                        try languageFolder.createFile(named: "Localizable.strings")
                    }
                    
                    file = try languageFolder.file(named: "Localizable.strings")
                    try file.write("")
                    
                } else {
                    
                    let languageFolder = try folder.createSubfolder(named: "\(language).lproj")
                    try languageFolder.createFile(named: "Localizable.strings")
                    file = try languageFolder.file(named: "Localizable.strings")
                    
                }
                try file.write(localizabeText)
            })
        } catch  {
            print("❌ ERROR CREATING THE LOCALIZABLE STRING FILE ❌".red)
        }
    }
}
