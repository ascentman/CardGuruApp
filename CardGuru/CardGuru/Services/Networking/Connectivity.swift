//
//  Connectivity.swift
//  CardGuru
//
//  Created by Vova on 11/13/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import Alamofire

final class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
