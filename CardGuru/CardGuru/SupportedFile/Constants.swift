//
//  StoryboardName.swift
//  CardGuru
//
//  Created by Vova on 10/2/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation

enum Constants {
    enum StoryboardName {
        static let login = "Login"
        static let main = "Main"
    }
    // це краще окремим файликом enum і до файлів з логінізацією
    // виглядає так шо в тебе тут буде 100500 enum різних в яких потім ладу ніхьто не дасть
    enum LoginMethod {
        static let facebook = "Facebook"
        static let google = "Google"
    }
}
