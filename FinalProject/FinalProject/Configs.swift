//
//  Configs.swift
//  FinalProject
//
//  Created by Sean Ward on 4/26/17.
//  Copyright © 2017 Sean Ward. All rights reserved.
//

import UIKit

let classURL = URL(string: "https://dl.dropboxusercontent.com/u/7544475/S65g.json")

class Configs : NSObject {
    
    let fetcher = Fetcher()
    var gridPatterns: [Config] = [Config]()
    
    func getData(url: URL, completion: @escaping (_ patterns : [Any]) -> Void) {
        Fetcher().fetchJSON(url: classURL!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            OperationQueue.main.addOperation {
                print("in fetchJSON closure")
                if let array = json as? [Any] {
                    completion(array)
                    //                    for pattern in array {
                    //                        let jsonDictionary = pattern as! [String : Any]
                    //                        let config = Config(json: jsonDictionary)
                    //                        self.gridPatterns.append(config)
                    //                    }
                }
            }
        }
    }
    
//    func getData(url: URL, completion: @escaping (_ patterns : [Any]) -> Void) {
//        Fetcher().fetchJSON(url: classURL!) { (json: Any?, message: String?) in
//            guard message == nil else {
//                print(message ?? "nil")
//                return
//            }
//            guard let json = json else {
//                print("no json")
//                return
//            }
//            OperationQueue.main.addOperation {
//                print("in fetchJSON closure")
//                if let array = json as? [Any] {
//                    completion(array)
//                    //                    for pattern in array {
//                    //                        let jsonDictionary = pattern as! [String : Any]
//                    //                        let config = Config(json: jsonDictionary)
//                    //                        self.gridPatterns.append(config)
//                    //                    }
//                }
//            }
//        }
//    }
    
//    var gridPatterns: [Config] = {
//        Fetcher().fetchJSON(url: classURL!) { (json: Any?, message: String?) in
//            guard message == nil else {
//                print(message ?? "nil")
//                return
//            }
//            guard let json = json else {
//                print("no json")
//                return
//            }
//            OperationQueue.main.addOperation {
//                print("in fetchJSON closure")
//                var patterns = [Any]()
//                if let array = json as? [Any] {
//                    for pattern in array {
//                        let jsonDictionary = pattern as! [String : Any]
//                        let config = Config(json: jsonDictionary)
//                        patterns.append(config)
//                    }
//                }
//            }
//        }
//        return test as! [Config]
//    }()
    
//    init(_ url: URL) {
//        fetcher.fetchJSON(url: url) { (json: Any?, message: String?) in
//            guard message == nil else {
//                print(message ?? "nil")
//                return
//            }
//            guard let json = json else {
//                print("no json")
//                return
//            }
//            OperationQueue.main.addOperation {
//                print("in fetchJSON closure")
//                if let array = json as? [Any] {
//                    for pattern in array {
//                        let jsonDictionary = pattern as! [String : Any]
//                        let config = Config(json: jsonDictionary)
//                        self.patterns.append(config)
//                    }
//                }
//            }
//        }
//    }
}
