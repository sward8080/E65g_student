//
//  GridView.swift
//  Assignment3
//
//  Created by Sean Ward on 3/19/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var grid = Grid(0,0)
    @IBInspectable var size: Int = 20 {
        willSet(gridSize) {
            grid = Grid(gridSize, gridSize)
        }
    }
    
    @IBInspectable var livingColor: UIColor = UIColor.yellow
    @IBInspectable var emptyColor: UIColor = UIColor.white
    @IBInspectable var bornColor: UIColor = UIColor.green
    @IBInspectable var diedColor: UIColor = UIColor.black
    @IBInspectable var gridColor: UIColor = UIColor.purple

    @IBInspectable var gridWidth: CGFloat = 4.0
    
    override func draw(_ rect: CGRect) {
        //create the path
        let path = UIBezierPath()
        for i in 0 ... size {
            var vStart = CGPoint(
                x: rect.origin.x + ((rect.size.width * CGFloat(i)) / CGFloat(size)),
                y: rect.origin.y
            )
            print("i: \(i)     size: \(size)")
            var vEnd = CGPoint(
                x: rect.origin.x + ((rect.size.width * CGFloat(i)) / CGFloat(size)),
                y: rect.origin.y + rect.size.height
            )
            var hStart = CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + ((rect.size.height * CGFloat(i)) / CGFloat(size))
            )
            var hEnd = CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + ((rect.size.height * CGFloat(i)) / CGFloat(size))
            )
        
            //set the path's line width to the height of the stroke
            path.lineWidth = gridWidth
            
            //move the initial point of the path
            //to the start of the vertical stroke
            path.move(to: vStart)
            
            //add a point to the path at the end of the stroke
            path.addLine(to: vEnd)
            
            //move the initial point of the path
            //to the start of the horizontal stroke
            path.move(to: hStart)
            
            //add a point to the path at the end of the stroke
            path.addLine(to: hEnd)
        }
        let cellSize = CGSize(
            width: rect.size.width / CGFloat(size),
            height: rect.size.height / CGFloat(size)
        )
        let base = rect.origin
        (0 ..< size).forEach { i in
            (0 ..< size).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(i) * cellSize.width),
                    y: base.y + (CGFloat(j) * cellSize.height)
                )
                let subRect = CGRect(
                    origin: origin,
                    size: cellSize
                )
                let cellPath = UIBezierPath(ovalIn: subRect)
                switch grid[row: i, col: j] {
                    case .alive: livingColor.setFill()
                    case .empty: emptyColor.setFill()
                    case .born: bornColor.setFill()
                    case .died: diedColor.setFill()
                }
                cellPath.fill()
            }
        }
            //draw the stroke
            gridColor.setStroke()
            path.stroke()
    }
}
