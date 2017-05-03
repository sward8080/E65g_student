//
//  TableData.swift
//  FinalProject
//
//  Created by Sean Ward on 4/26/17.
//  Copyright © 2017 Sean Ward. All rights reserved.
//

import UIKit

let classURL = URL(string: "https://dl.dropboxusercontent.com/u/7544475/S65g.json")

struct TableData {
    
    var gridPatterns: [Config] = [Config]()
    var count : Int = 0
    
    subscript(index: Int) -> Config {
        get { return gridPatterns[index] }
        set { gridPatterns[index] = newValue }
    }
    
    init(jsonArray: [Any]) {
        for item in jsonArray {
            let config = item as! [String : Any]
            let golConfig = Config(json: config)
            gridPatterns.append(golConfig)
            count += 1
        }
    }
    
    func initializeEditor(_ config: Int) -> GridProtocol {
        let gridConfig = self[config].alive
        guard !gridConfig.isEmpty else { return Grid(10, 10) }
        let max : Int = gridConfig.joined().max()!
        var newGrid = Grid(newGridSize(max), newGridSize(max))
        gridConfig.forEach { newGrid[$0[0], $0[1]] = .alive }
        return newGrid
    }
    
    private func newGridSize(_ max: Int) -> Int {
        switch max {

        case 16...20: return 25
        case 21...30: return 40
        case 31...40: return 50
        case 41...60: return 75
        default: return 20
        }
    }
}

struct Config {
    
    var title : String = "Configuration"
    var alive : [[Int]] = [[Int]]()
    var born : [[Int]] = [[Int]]()
    var died : [[Int]] = [[Int]]()
}

extension Config {
    init(json: [String : Any]) {
        let title = json["title"] as! String
        let alive = json["contents"] as! [[Int]]
//        print("contents maxGridLocation: \(contents.joined().max())")
        
        self.title = title
        self.alive = alive
    }
    
    init(json: [String : [[Int]]]) {
        let alive = json["alive"]
        let born = json["born"]
        let died = json["died"]
        //        print("contents maxGridLocation: \(contents.joined().max())")
        
        self.alive = alive!
        self.born = born!
        self.died = died!
    }
    
    func initializeGrid(_ config: Config, _ size: Int) -> GridProtocol {
        var newGrid = Grid(size, size)
        for cell in config.alive {
            newGrid[cell[0], cell[1]] = .alive }
        for cell in config.born {
            newGrid[cell[0], cell[1]] = .born }
        for cell in config.died {
            newGrid[cell[0], cell[1]] = .died }
        newGrid.savedState = [ "born" : config.born,
                               "alive" : config.alive,
                               "died" : config.died ]
        return newGrid
    }
}
