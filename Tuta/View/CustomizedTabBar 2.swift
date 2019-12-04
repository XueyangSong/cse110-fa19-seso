//
//  CustomizedTabBar.swift
//  Tuta
//
//  Created by JIAHE LIU on 11/23/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit

private let darkBlueColor = UIColor(red:0.24, green:0.44, blue:0.64, alpha:1.0)

@IBDesignable
class CustomizedTabBar: UITabBar {
    private var shapeLayer:  CALayer?
    
    override func draw(_ rect: CGRect){
        self.addShape()
        self.tintColor = darkBlueColor
    }
    //点击在按钮里面
    /*override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRadius: CGFloat = 35
        return abs(self.center.x - point.x) > buttonRadius || abs(point.y) > buttonRadius
    }*/
    
    private func addShape(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = creatPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        if let oldShapeLayer = self.shapeLayer{
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else{
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    func creatPath() -> CGPath {
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
        
        path.addCurve(to: CGPoint(x: centerWidth, y: height), controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
        path.addCurve (to: CGPoint(x: (centerWidth + height * 2), y: 0), controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y:  0))
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
        

    }

}

