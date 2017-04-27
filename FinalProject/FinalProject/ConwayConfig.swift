//
//  ConwayConfig.swift
//  FinalProject
//
//  Created by Sean Ward on 4/26/17.
//  Copyright © 2017 Sean Ward. All rights reserved.
//

import Foundation

//struct Config {
//    
//    let title : String
//    let contents : [[Int]]
//}
//
//extension Config {
//    init?(json: [String: Any]) {
//        guard let title = json["title"] as? String,
//            let contents = json["contents"] as? [[Int]]
//            else {
//                return nil
//        }
//        
//        self.title = title
//        self.contents = contents
//    }
//}

struct Config {
    
    let title : String
    let contents : [[Int]]
}

extension Config {
    init(json: [String: Any]) {
        let title = json["title"] as! String
        let contents = json["contents"] as! [[Int]]
        
        self.title = title
        self.contents = contents
    }
}
