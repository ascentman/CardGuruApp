//
//  FileManager.swift
//  CardGuru
//
//  Created by Vova on 11/21/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation

final class FileHandler {
    
    private let fileManager = FileManager.default
    private var documentDirectory : URL? {
        get {
            guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }
            return documentDirectory
        }
    }
    
    private var plistFile : URL? {
        get {
            guard let documentDirectory = documentDirectory else {
                return nil
            }
            return documentDirectory.appendingPathComponent("ShortcutItem.plist")
        }
    }
    
    func readDataFromPlist() throws -> LastCard {
        var lastCard = LastCard()
        guard let plist = plistFile else {
            throw ErrorToThrow.failToReadFromPlist
        }
        do {
            let data = try Data(contentsOf: plist)
            let decoder = PropertyListDecoder()
            lastCard = try decoder.decode(LastCard.self, from: data)
        } catch {
            throw ErrorToThrow.failToReadFromPlist
        }
        return lastCard
    }
    
    func writeDataToPlist(lastCard: LastCard) throws {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            let data = try encoder.encode(lastCard)
            if let plist = plistFile {
                try data.write(to: plist)
            }
        } catch {
            throw ErrorToThrow.failWriteToPlist
        }
    }
}
