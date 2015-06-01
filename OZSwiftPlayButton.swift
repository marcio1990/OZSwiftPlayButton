//
//  OZSwiftPlayButton.swift
//  OZSwiftPlayButton
//
//  Created by Otavio Zabaleta on 01/06/2015.
//  Copyright (c) 2015 DXI. All rights reserved.
//

import UIKit
import Foundation

protocol OZSwiftPlayButtonDelegate {
    func didFinish()
}

class OZSwiftPlayButton : UIButton {
    // ---------- Public properties ----------
    var delegate: OZSwiftPlayButtonDelegate?
    var duration: NSTimeInterval = 0
    var updateInterval = 0.05 // Default time interval for progress updating
    private var _currentTime: NSTimeInterval! = 0
    var currentTime: NSTimeInterval {
        get {
            return _currentTime
        }
        set {
            _currentTime = newValue
            self.currentTimePercent = _currentTime / self.duration;
            setNeedsDisplay()
        }
    }

    // ---------- Private Properties ----------
    private var currentTimePercent: Double = 0
    var a, b, c, d, e, f, g: CGPoint?
    var timer: NSTimer! = nil
    
    // ================================================================================
    // MARK - Lifecycle                                                               |
    // ================================================================================
    override func awakeFromNib() {
        setBasicStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBasicStyle()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBasicStyle()
    }
    
    // Custom Initializer
    init(frame: CGRect, andDuration aDuration: NSTimeInterval) {
        super.init(frame: frame)
        setBasicStyle()
        self.duration = aDuration
    }
    
    // ================================================================================
    // MARK - Public API                                                              |
    // ================================================================================
    func touchUpInside() {
        setSelectedValue(!selected)
    }
    
    // ================================================================================
    // MARK - Private                                                                 |
    // ================================================================================
    private func setBasicStyle() {
        layer.cornerRadius = frame.size.width / 2
        layer.borderWidth = 2.0
        layer.borderColor = tintColor?.CGColor
        clipsToBounds = true
        currentTime = 0
        currentTimePercent = 0
        duration = 0
        setTitleForAllStates("")
        let r: CGFloat = frame.size.width / 2
        let offset: CGFloat = frame.size.width * 0.15
        a = CGPointMake(r + (cos(degreesToRadians(degree: 135.0)) * r) + offset, r - (sin((degreesToRadians(degree: 135.0)) * r) + offset))
        b = CGPointMake(r + (cos(degreesToRadians(degree: 225.0)) * r) + offset, frame.size.height - offset - (sin((degreesToRadians(degree: 225.0)) * r) + offset))
        c = CGPointMake(self.frame.size.width - offset * 1.85, self.frame.size.height / 2)
        d = CGPointMake(r - (0.7 * offset), self.a!.y);
        e = CGPointMake(r - (0.7 * offset), self.b!.y);
        f = CGPointMake(r + (0.7 * offset), self.a!.y);
        g = CGPointMake(r + (0.7 * offset), self.b!.y);
    }
    
    private func setSelectedValue(isSelected: Bool) {
        self.selected = isSelected
        if timer != nil {
            timer.invalidate()
        }
        
        if self.selected {
            timer = NSTimer.scheduledTimerWithTimeInterval(updateInterval, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        }
    }
    
    func updateTime() {
        let newTime: NSTimeInterval = self.currentTime + self.updateInterval
        if newTime >= duration {
            _currentTime = 0
            selected = false
            timer.invalidate()
            if (delegate != nil) {
                delegate!.didFinish()
            }
        }
        else {
            self.currentTime = newTime
        }
    }
    
    override func drawRect(rect: CGRect) {
        if backgroundColor == nil {
            backgroundColor = UIColor.whiteColor()
        }
        if !selected {
            layer.borderWidth = 0
            tintColor?.setStroke()
            tintColor?.setFill()
            let triangle = UIBezierPath()
            triangle.moveToPoint(a!)
            triangle.addLineToPoint(b!)
            triangle.addLineToPoint(c!)
            triangle.closePath()
            triangle.stroke()
            triangle.fill()
        }
        else {
            layer.borderWidth = 2.0
            layer.borderColor = tintColor?.CGColor
            tintColor?.setFill()
            tintColor?.setStroke()
            let backGround = UIBezierPath(arcCenter: CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2), radius: self.frame.size.width / 2, startAngle: 0, endAngle: degreesToRadians(degree: 360), clockwise: true)
            backGround.fill()
            backGround.stroke()
            
            
            backgroundColor!.setStroke()
            var lineWidth: CGFloat = self.frame.size.width / 15;
            if lineWidth < 3 {
                lineWidth = 3
            }
            let progress = UIBezierPath(arcCenter: CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2), radius: (self.frame.size.width / 2) - lineWidth, startAngle: 0, endAngle: degreesToRadians(degree: CGFloat(360.0 * currentTimePercent)), clockwise: true)
            
            progress.lineWidth = lineWidth
            progress.stroke()
            
            let lines = UIBezierPath()
            lines.lineWidth = self.frame.size.width / 10;
            lines.moveToPoint(d!)
            lines.addLineToPoint(e!)
            lines.stroke()
            lines.moveToPoint(f!)
            lines.addLineToPoint(g!)
            lines.stroke()
        }
    }
    
    // ---------- Utilitaty Functions ----------
    private func degreesToRadians(degree aDegree: CGFloat) -> CGFloat {
        return aDegree * CGFloat(M_PI) / 180.0
    }
    
    private func setTitleForAllStates(title: String) {
        setTitle(title, forState: .Normal)
        setTitle(title, forState: .Highlighted)
        setTitle(title, forState: .Selected)
        setTitle(title, forState: .Disabled)
    }
}