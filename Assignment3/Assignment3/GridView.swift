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
        let base = rect.origin
        let viewWidth = rect.size.width
        let viewHeight = rect.size.height
        
        // Determine size of each cell
        let cellSize = CGSize(
            width: viewWidth / CGFloat(size),
            height: viewHeight / CGFloat(size)
        )
        
        // Create circles for cells
        (0 ..< size).forEach { i in
            (0 ..< size).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(i) * cellSize.width),
                    y: base.y + (CGFloat(j) * cellSize.height)
                )
                
                // Define subretangles for
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
        
        //Create path for gridlines
        let path = UIBezierPath()
        
        for i in 0 ... size {
            let vStart = CGPoint(
                x: base.x + ((viewWidth * CGFloat(i)) / CGFloat(size)),
                y: base.y
            )
            let vEnd = CGPoint(
                x: base.x + ((viewWidth * CGFloat(i)) / CGFloat(size)),
                y: base.y + viewHeight
            )
            let hStart = CGPoint(
                x: base.x,
                y: base.y + ((viewHeight * CGFloat(i)) / CGFloat(size))
            )
            let hEnd = CGPoint(
                x: base.x + viewWidth,
                y: base.y + ((viewHeight * CGFloat(i)) / CGFloat(size))
            )
        
            //set the line width of path
            path.lineWidth = gridWidth
            
            //move the initial point of the path
            //to the start of the vertical stroke
            path.move(to: vStart)
            
            //add a point to the path at the end of vertical stroke
            path.addLine(to: vEnd)
            
            //move the initial point of the path
            //to the start of the horizontal stroke
            path.move(to: hStart)
            
            //add a point to the path at the end of horizontal stroke
            path.addLine(to: hEnd)
        }
        
        //draw gridlines
        gridColor.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cellLastTouched = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        cellLastTouched = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cellLastTouched = nil
    }
    
    var cellLastTouched: Position?
    func process(touches: Set<UITouch>) -> Position? {
        
        // If multitouch, return nil
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        
        // If same cell touched 2X, return position of cell touched
        guard cellLastTouched?.row != pos.row
            || cellLastTouched?.col != pos.col
            else { return pos }
        
        // Toggle cellState of cell touched
        let currentCell = grid[(pos.col, pos.row)]
        grid[(pos.col, pos.row)] = grid[(pos.col, pos.row)].toggle(value: currentCell)
        setNeedsDisplay()
        return pos
    }
    
    // Convert UITouch object to valid cell position
    func convert(touch: UITouch) -> Position {
        let touchY = Int(touch.location(in: self).y)
        let gridHeight = Int(frame.size.height)
        let row = touchY / (gridHeight / size)
        let touchX = Int(touch.location(in: self).x)
        let gridWidth = Int(frame.size.width)
        let col = touchX / (gridWidth / size)
        let position = (row, col)
        return position
    }
    
    // Iterate grid
    func stepPressedNextGrid() {
        grid = grid.next()
        setNeedsDisplay()
    }

}
