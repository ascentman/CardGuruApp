//
//  Downloader.swift
//  CardGuru
//
//  Created by Vova on 11/5/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

final class Downloader {
    
    static let shared = Downloader()
    private init() {}
    
    func loadImage(_ from: String?, _ completion: @escaping (_ image: UIImage?) -> ()) {
        guard let from = from else {
            completion(nil)
            return
        }
        Alamofire.request(from).responseImage { response in
            if let image = response.result.value {
                completion(image)
            }
        }
    }
}
