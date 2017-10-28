//: Playground - noun: a place where people can play

import UIKit

class AnimatedLogoSuperView: UIView {
    
    // MARK: Properties
    var image: UIImage? {
        didSet {
            setup()
        }
    }
    var views = [AnimatedLogoView]()
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        
        setup()
    }
    var verticalCount: Int = 0
    func setup() {
        if let image = image {
            self.backgroundColor = UIColor.clear
            
            let logoWidth = self.frame.width / 5
            
            for i in 0..<5 {
                let proportion = image.size.height / image.size.width
                let height = logoWidth * proportion
                
                let y = (i % 2 == 0) ? -height : -height/2
                
                verticalCount = Int((self.frame.height / height) + 1)
                
                for j in 0...verticalCount {
                    
                    let view = AnimatedLogoView(frame: CGRect(x: logoWidth * CGFloat(i), y: y + CGFloat(j) * height, width: logoWidth, height: height))
                    view.logoImage = image
                    view.delay = 0
                    
                    self.addSubview(view)
                    views.append(view)
                    
                }
            }
        }
        
    }
    
    
    func startAnimation() {
        var i = 0
        var j: Double = 0.3
        for view in views {
            
            if (i % (verticalCount + 1)) == 0 {
                j = 0.3
            }
            
            view.startAnimation(j)

            i += 1
            j += 0.1
        }
    }
    
    func stopAnimation() {
        for view in views {
            view.stopAnimation()
        }
    }
}

class AnimatedLogoView: UIView {
    
    // MARK: Properties
    var logoImage = UIImage(named: "logo-back-1")! {
        didSet {
            setup()
        }
    }
    var image1Prop: CGFloat = 0
    var logo1ImageView = UIImageView()
    var logo1Wrap = UIView()
    var delay: TimeInterval = 0
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.clear
        
        setupImages()
        setupWrappers()
        
        logo1Wrap.addSubview(logo1ImageView)
        
        
        self.addSubview(logo1Wrap)
        
        
        //        animate()
        
        
    }
    
    func setupImages() {
        image1Prop = logoImage.size.height / logoImage.size.width
        
        logo1ImageView.image = logoImage
        
        logo1ImageView.tintColor = UIColor.red
        
        logo1ImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        logo1ImageView.backgroundColor = UIColor.white
        
        logo1ImageView.frame.size.width = self.frame.size.width
        
        logo1ImageView.frame.size.height = logo1ImageView.frame.size.width * image1Prop
        
        
    }
    
    func setupWrappers() {
        logo1Wrap.backgroundColor = UIColor.white
        
        logo1Wrap.clipsToBounds = true
        
        logo1Wrap.frame.size.width = self.frame.size.width
        logo1Wrap.frame.size.height = logo1Wrap.frame.size.width * image1Prop
        
        
    }
    
    func stopAnimation() {
        self.logo1Wrap.layer.removeAllAnimations()
       
    }
    
    func startAnimation() {
        logo1Wrap.frame.size.width = 0
        UIView.animate(withDuration: 5, delay: delay, options: [],
            animations: {
                self.logo1Wrap.frame.size.width = self.frame.size.width
            },
            completion: { (complete)->() in
                
        })
    }
    
    func startAnimation(_ time: Double) {
        logo1Wrap.frame.size.width = 0
        UIView.animate(withDuration: time, delay: delay, options: [],
            animations: {
                self.logo1Wrap.frame.size.width = self.frame.size.width
            },
            completion: { (complete)->() in
                
        })
    }
    
    override var intrinsicContentSize : CGSize {
        let buttonSize = Int(frame.size.height)
        //        let width = (buttonSize + spacing) * stars
        
        return CGSize(width: buttonSize, height: buttonSize)
    }
}
