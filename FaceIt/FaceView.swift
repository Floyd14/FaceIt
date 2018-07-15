//
//  FaceView.swift
//  FaceIt
//
//  Created by Andrea Visini on 15/07/18.
//  Copyright © 2018 Andrea Visini. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    
    let scaleFactor: CGFloat = 0.9
    let pathWidth: CGFloat = 5.0
    
    private var skullCenter: CGPoint {
        return  CGPoint(x: bounds.midX, y: bounds.midY)
    }
    private var skullRadius: CGFloat {
        return min(bounds.size.width,bounds.size.height)/2 * scaleFactor
    }
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat(2*Double.pi),
            clockwise: true
        )
        
        path.lineWidth = pathWidth
        UIColor.blue.set()
        return path
    }
    
    
    private func pathForEye(eye: Eye) -> UIBezierPath {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
    }
    
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(
            x: skullCenter.x - mouthWidth/2,
            y: skullCenter.y + mouthOffset/2,
            width: mouthWidth,
            height: mouthHeight
        )
        
        return UIBezierPath(rect: mouthRect)
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        
        pathForMouth().stroke()
        
    }
    
    
}
