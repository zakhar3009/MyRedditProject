//
//  Bookmark.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 28.02.2024.
//

import Foundation
import UIKit

class Bookmark: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(){
        self.backgroundColor = UIColor.clear
        let path = getUIBezierPath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.systemBlue.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    
    func getUIBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.width * 0.1,
                              y: self.frame.height * 0.1)
        )
        path.addLine(to: CGPoint(x: self.frame.width * 0.9,
                                 y: self.frame.height * 0.1)
        )
        path.addLine(to: CGPoint(x: self.frame.width * 0.9,
                                 y: self.frame.height * 0.9)
        )
        path.addLine(to: CGPoint(x: self.frame.width * 0.5,
                                 y: self.frame.height * 0.65)
        )
        path.addLine(to: CGPoint(x: self.frame.width * 0.1,
                                 y: self.frame.height * 0.9)
        )
        path.close()
        return path
    }
}
