
import UIKit
import XCPlayground

extension UIColor{
  var rgb:[CGFloat]{
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0
    getRed(&r, green: &g, blue: &b, alpha: &a)
    return [r,g,b,a]
  }
}

class DrawView:UIView{
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  override func drawRect(rect: CGRect) {
    let colors :[UIColor] = [UIColor.redColor(), UIColor.orangeColor(),UIColor.greenColor(),UIColor.cyanColor()]
    
    let locations = [0,7,9,12].map{ CGFloat($0) / 12.0 }
    locations
    let rgbas = colors.map{$0.rgb}.reduce([CGFloat]()){ $0 + $1 }
    rgbas
    let baseSpace = CGColorSpaceCreateDeviceRGB()
    let count = CGColorSpaceGetNumberOfComponents(baseSpace)
    
    let gradient = CGGradientCreateWithColorComponents(baseSpace, rgbas, locations, locations.count)
    
    
    let path = UIBezierPath(ovalInRect: rect.insetBy(dx: 10, dy: 10))
    path.lineWidth = 10
    
    let ctx = UIGraphicsGetCurrentContext()
    CGContextAddPath(ctx, path.CGPath)
    CGContextSetLineJoin(ctx, .Round)
    CGContextSetLineCap(ctx, .Round)
    
    CGContextSetLineWidth(ctx, 10)
    //    CGContextReplacePathWithStrokedPath(ctx)
    let startPoint = CGPoint(x: 0.0, y:rect.midY)
    let endPoint = CGPoint(x: rect.maxX, y: rect.midY)
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, [])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


class DrawViewV2:UIView{
  
  var annularBackgroundColor = UIColor(white: 0.45, alpha: 1.0){
    didSet{
      self.annularBackgroundLayer.strokeColor = annularBackgroundColor.CGColor
    }
  }
  
  lazy var annularBackgroundLayer :CAShapeLayer = {
    let shape = CAShapeLayer()
    shape.strokeColor = self.annularBackgroundColor.CGColor
    shape.fillColor = UIColor.clearColor().CGColor
    shape.lineWidth = self.lineWidth
    self.layer.addSublayer(shape)
    return shape
  }()
  
  lazy var annularLayer  :  CAGradientLayer = {
    let annularLayer = CAGradientLayer()
    self.layer.addSublayer(annularLayer)
    let colors :[CGColorRef] = [UIColor.redColor(),UIColor.orangeColor(),UIColor.yellowColor(), UIColor.greenColor(),UIColor.greenColor(), UIColor.greenColor()].map{$0.CGColor}
    let locations = [0,3,6,8,9,12].map{ CGFloat($0) / 12.0 }
    annularLayer.colors = colors
    annularLayer.locations = locations
    annularLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    annularLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    return annularLayer
  }()
  
  lazy var maskLayer : CAShapeLayer = {
    let maskLayer  = CAShapeLayer()
    maskLayer.fillColor = UIColor.clearColor().CGColor
    maskLayer.strokeColor = UIColor.whiteColor().CGColor
    maskLayer.lineWidth = self.lineWidth
    maskLayer.lineJoin = "round"
    maskLayer.lineCap = "round"
    self.annularLayer.mask = maskLayer
    return maskLayer
  }()
  
  var startAngle:CGFloat = CGFloat(M_PI_2)
  var progress:CGFloat = 0.4{
    didSet{
      updatePath()
    }
  }
  
  var endAngle:CGFloat {
    let angle = progress * CGFloat(M_PI) * 2
    return startAngle + angle
  }
  
  var maskPath:UIBezierPath{
    return  UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: CGFloat(M_PI / 2.0), endAngle: endAngle, clockwise: true)
  }
  
  var radius:CGFloat{
    return bounds.width * 0.5 - lineWidth * 0.5
  }
  
  var lineWidth :CGFloat = 15{
    didSet{
      updatePath()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    annularBackgroundLayer.frame = bounds
    annularLayer.frame = bounds
    maskLayer.frame = bounds
    updatePath()
  }
  
  func updatePath(){
    let path = UIBezierPath(ovalInRect: bounds.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5))
    annularBackgroundLayer.path = path.CGPath
    maskLayer.path = maskPath.CGPath
    playProgressAnimation()
  }
  
  
  func playProgressAnimation(){
    let anim = CABasicAnimation(keyPath: "strokeEnd")
    anim.duration = 1.0
    anim.repeatCount = 1.0
    anim.removedOnCompletion = false
    anim.fromValue = 0.0
    anim.toValue = 1.0
    anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    maskLayer.addAnimation(anim, forKey: "drawArc")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class DrawClockView:UIView{
  var annularBackgroundColor = UIColor(white: 0.96, alpha: 1.0){
    didSet{
      setNeedsDisplay()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clearColor()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  var startAngle:CGFloat = 0{
    didSet{
      setNeedsDisplay()
    }
  }
  var totalAngle:CGFloat = CGFloat(M_PI * 2){
    
    didSet{
      setNeedsDisplay()
    }
  }
  
  var markerPaddingIn :CGFloat = 4
  var markerPaddingOut :CGFloat = 2
  
  var shortMarkerWidth: CGFloat = 2{
    didSet{
      setNeedsDisplay()
    }
  }
  var longMarkerWidth :CGFloat = 2{
    didSet{
      setNeedsDisplay()
    }
  }
  var shortMarkerSize:CGFloat = 15{
    didSet{
      setNeedsDisplay()
    }
  }
  var longMarkerSize:CGFloat = 30{
    didSet{
      setNeedsDisplay()
    }
  }
  var markerCount:UInt = 11{
    didSet{
      setNeedsDisplay()
    }
  }
  
  var markerMod:UInt = 3{
    didSet{
      setNeedsDisplay()
    }
  }
  
  var markerColor:UIColor = UIColor(white: 0.78, alpha: 1.0){
    didSet{
      setNeedsDisplay()
    }
  }
  
  
  lazy var annularLayer:CAShapeLayer = {
    let shape = CAShapeLayer()
    self.layer.addSublayer(shape)
    return shape
  }()
  
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    let annularWidth = longMarkerSize + markerPaddingIn + markerPaddingOut
    
    let inset = annularWidth * 0.5
    let annularPath = UIBezierPath(ovalInRect: rect.insetBy(dx: inset, dy: inset))
    annularPath.lineWidth = annularWidth
    annularBackgroundColor.setStroke()
    let ctx = UIGraphicsGetCurrentContext()
    
    CGContextSetShadowWithColor(ctx, CGSize(width: 2, height: 3), 0.5, UIColor.whiteColor().CGColor)
    annularPath.stroke()
    
    CGContextSaveGState(ctx)
    markerColor.set()
    CGContextSetLineWidth(ctx, 1.0)
    
    CGContextTranslateCTM(ctx, bounds.midX, bounds.midY)
    
    let lineRect = CGRect(x: -longMarkerWidth * 0.5, y: 0, width: longMarkerWidth, height: longMarkerSize)
    let shortRect = CGRect(x: -shortMarkerWidth * 0.5, y: 0, width: shortMarkerWidth, height: shortMarkerSize)
    
    let linePath = UIBezierPath(rect: lineRect)
    let shortPath = UIBezierPath(rect: shortRect)
    linePath.lineCapStyle = .Round
    linePath.lineJoinStyle = .Round
    
    
    let radius = bounds.width * 0.5 - markerPaddingOut
    
    for dial in (0...markerCount){
      CGContextSaveGState(ctx)
      let angle =  startAngle +   CGFloat(dial) / CGFloat(markerCount + 1) * totalAngle
      CGContextRotateCTM(ctx, angle)
      if dial % markerMod == 0{
        CGContextTranslateCTM(ctx, 0, radius - longMarkerSize)
        linePath.fill()
        
      }else{
        CGContextTranslateCTM(ctx, 0, radius - shortMarkerSize)
        shortPath.fill()
      }
      CGContextRestoreGState(ctx)
      
    }
    CGContextRestoreGState(ctx)
    
  }
}

let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
backgroundView.backgroundColor = .whiteColor()

let drawView = DrawClockView(frame: CGRect(x: 0, y: 0, width: 240 + 76, height: 240 + 76))
drawView.center = backgroundView.center
drawView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
backgroundView.addSubview(drawView)

let drawView2 = DrawViewV2(frame: CGRect(x: 0, y: 0, width: 230, height: 230))
drawView2.center = backgroundView.center
//drawView2.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
backgroundView.addSubview(drawView2)
XCPlaygroundPage.currentPage.liveView = backgroundView

