//
//  ErrorToThrow.swift
//  CardGuru
//
//  Created by Vova on 11/21/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation

enum ErrorToThrow : Error {
    case failToReadFromPlist
    case failWriteToPlist
}
