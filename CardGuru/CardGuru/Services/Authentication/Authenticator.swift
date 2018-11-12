//
//  Authenticator.swift
//  CardGuru
//
//  Created by Vova on 11/9/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import LocalAuthentication

final class Authenticator {
    
    static let shared = Authenticator()
    private init() {}
    
    private var context: LAContext?
    
    func loggingWithTouchId(completion: @escaping (Bool, Error?)->()) {
        context = LAContext()
        if let context = context {
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Logging with Touch ID") { (success, error) in
                    completion(success, error)
                }
            }
        }
    }
}
