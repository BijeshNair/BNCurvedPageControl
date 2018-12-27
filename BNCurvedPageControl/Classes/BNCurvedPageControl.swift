//
//  BNCurvedPageControl.swift
//  BezierPath
//
//  Created by Bijesh on 20/12/18.
//  Copyright © 2018 Bijesh. All rights reserved.
//

import UIKit

public protocol BNCurvedPageControlDelegate: class {
    func goToPage(_ button: UIButton!)
}

open class BNCurvedPageControl: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    open weak var delegate: BNCurvedPageControlDelegate?
    
    var path: UIBezierPath!
    open var buttonColor:UIColor = .white
    open var lineColor:UIColor = .white
    open var buttonSelectedColor:UIColor = .darkGray
    open var numberOfPoints:Int = 0
    open var currentPage:Int = 0
    
    var P0:CGPoint = CGPoint.init()
    var P1:CGPoint = CGPoint.init()
    var P2:CGPoint = CGPoint.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isOpaque = true
    }
    
    /* MARK: For future use
    func createLine () {
        
        path = UIBezierPath()
        path.lineWidth = 3.0
        path.lineJoinStyle = .round
        path.move(to: CGPoint(x: 0, y: self.frame.size.height-10))
        path.addLine(to: CGPoint(x: 414.0, y: self.frame.size.height-250))
        
        var path2: UIBezierPath!
        path2 = UIBezierPath()
        path2.lineWidth = 1.0
        path2.lineJoinStyle = .round
        path2.move(to: CGPoint(x: 0, y: self.frame.size.height-10))
        path2.addLine(to: CGPoint(x: 414.0, y: self.frame.size.height-250))
        path2.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height+100))
        path2.addLine(to: CGPoint(x: 0, y: self.frame.size.height+100))
        path2.close()
        path2.addClip()

        let startColor: UIColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.4)
        let endColor: UIColor = .clear
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient2 = CGGradient(colorsSpace: colorSpace,
                                   colors: colors as CFArray,
                                   locations: colorLocations)!
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient2,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
    }
     */
    
    func createCurve() {
        
        P0 = CGPoint(x: 0, y: self.frame.size.height-20)
//        P1 = CGPoint(x: self.frame.size.width-self.frame.size.width/3, y: self.frame.size.height-20)
        P1 = CGPoint(x: self.frame.size.width, y: self.frame.size.height-20)
        P2 = CGPoint(x: self.frame.size.width, y: 0)
        
        path = UIBezierPath()
        path.lineWidth = 3.0
        path.lineJoinStyle = .round
        path.move(to: P0)
        path.addQuadCurve(to: P2, controlPoint: P1)
        
        var path2: UIBezierPath!
        path2 = UIBezierPath()
        path2.lineWidth = 1.0
        path2.lineJoinStyle = .round
        path2.move(to: P0)
        path2.addQuadCurve(to: P2, controlPoint: P1)
        path2.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path2.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        path2.close()
        path2.addClip()

        let startColor: UIColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.5)
        let endColor: UIColor = .clear
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient2 = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 0, y: bounds.height+50)
        context.drawLinearGradient(gradient2,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
        
    }
    
    override open func draw(_ rect: CGRect) {
        
        createCurve()
        plotButtons(x: numberOfPoints)
        goToIndicator(x: currentPage)
//        createLine()
        
        UIColor.clear.setFill()
        path.fill()
        
        lineColor.setStroke()
        path.stroke()
        
    }
    
    private func plotButtons(x:Int){
        
        for i in 0...x-1{
            
            let xPosition:CGFloat = 50+((CGFloat(self.frame.size.width-50)/CGFloat(x)) * CGFloat(i))

            var path2: UIBezierPath!
            path2 = UIBezierPath()
            path2.lineWidth = 3.0
            path2.lineJoinStyle = .round
            path2.move(to: CGPoint(x: xPosition, y: 0))
            path2.addLine(to: CGPoint(x: xPosition, y: self.frame.size.height))

//            t^2 * (P0.X - 2*P1.X + P2.X) + t * (-2*P0.X + 2*P1.X)  + (P0.X - LineX) = 0
            let a:CGFloat = (P0.x - (2*P1.x) + P2.x)
            let b:CGFloat = (-2*P0.x + 2*P1.x)
            let c:CGFloat = P0.x - xPosition

//            t = (-b±√(b^2-4ac))/2a
            let t1:CGFloat = (-b + sqrt(b * b - 4 * a * c)) / (2 * a)
            let t2:CGFloat = (-b - sqrt(b * b - 4 * a * c)) / (2 * a)
            print("t1: \(t1) and t2: \(t2)")
            var t:CGFloat
            if t1 < 1 && 0 < t1{
                t = t1
            }else{
                t = t2
            }
            print("t is: \(t)")

//            Y = P0.Y*(1-t)^2 + 2*P1.Y*(1-t)*t + P2.Y*t^2
            let yPosition:CGFloat = P0.y * ((1-t) * (1-t)) + 2 * P1.y * (1-t) * t + P2.y * t * t

            let btn:UIButton = UIButton.init(frame: CGRect.init(x: xPosition-10, y: yPosition-10, width: 20, height: 20))
            btn.backgroundColor = buttonColor
            btn.layer.cornerRadius = 10
            btn.layer.borderColor = lineColor.cgColor
            btn.layer.borderWidth = 2
            btn.tag = i
            btn.clipsToBounds = true
            btn.addTarget(self, action: #selector(BNCurvedPageControl.buttonClicked(sender:)), for: .touchUpInside)
            self.addSubview(btn)

        }

    }
    
    @objc func buttonClicked(sender: UIButton!){
        delegate?.goToPage(sender)
    }
    
    open func goToIndicator(x:Int){
        
        for btn:UIView in self.subviews {
            
            if btn is UIButton {
                btn.backgroundColor = buttonColor
                if btn.tag == x {
                    btn.backgroundColor = .clear
                    btn.backgroundColor = buttonSelectedColor
                }
            }
        }
        
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        for subview in subviews {
            if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
        
    }

}


//extension UIBezierPath {
//    convenience init(points:[CGPoint])
//    {
//        self.init()
//
//        //connect every points by line.
//        //the first point is start point
//        for (index,aPoint) in points.enumerated()
//        {
//            if index == 0 {
//                self.move(to: aPoint)
//            }
//            else {
//                self.addLine(to: aPoint)
//            }
//        }
//    }
//}
