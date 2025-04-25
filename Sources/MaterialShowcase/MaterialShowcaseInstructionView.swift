import UIKit
public class MaterialShowcaseInstructionView: UIView {
  
  // Constants for default configuration
  internal static let PRIMARY_TEXT_SIZE: CGFloat = 20
  internal static let SECONDARY_TEXT_SIZE: CGFloat = 15
  internal static let PRIMARY_TEXT_COLOR = UIColor.black
  internal static let SECONDARY_TEXT_COLOR = UIColor.darkGray
  internal static let PRIMARY_DEFAULT_TEXT = "Tips Heading"
  internal static let SECONDARY_DEFAULT_TEXT = "Lorem ipsum dolor sit amet consectetur. Et amet auctor cursus risus consectetur."
    @available(iOS 13.0, *)
    internal static let BACKGROUND_COLOR =  UIColor.systemGray6
    public var arrowAlignment: ArrowAlignment = .center {
        didSet {
            // Trigger layout refresh so arrow re-draws
            setNeedsLayout()
        }
    }
    public var arrowDirection: ArrowDirection = .up {
        didSet {
            setNeedsLayout()
        }
    }

    /// Optional offset to nudge the arrow more left/right
    public var arrowXOffset: CGFloat = 0
    private var arrowView: UIView?

  public var primaryLabel: UILabel!
  public var secondaryLabel: UILabel!
  private var arrowLayer: CAShapeLayer!
    let containerView = UIView()
  // Customizable properties
  public var primaryText: String!
  public var secondaryText: String!
  public var primaryTextColor: UIColor!
  public var secondaryTextColor: UIColor!
  public var primaryTextSize: CGFloat!
  public var secondaryTextSize: CGFloat!
  public var primaryTextFont: UIFont?
  public var secondaryTextFont: UIFont?
  public var primaryTextAlignment: NSTextAlignment!
  public var secondaryTextAlignment: NSTextAlignment!
    public var nextBtn: UIButton?
    public var skipBtn: UIButton?
    public var arrowImageView: UIImageView?
    public var nextButtonAction: (() -> Void)?
    public var skipButtonAction: (() -> Void)?
    public var showNextArrow = true
  // Arrow dimensions
  private let arrowHeight: CGFloat = 17
  private let arrowWidth: CGFloat = 22
  private let cornerRadius: CGFloat = 12
  private let padding: CGFloat = 16
    public weak var controller: MaterialShowcaseController?
    public init() {
    // Create frame
    let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: 0)
    super.init(frame: frame)
        
    configure()
      
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Configures default properties and sets up the view
  private func configure() {
    setDefaultProperties()
      if #available(iOS 13.0, *) {
          backgroundColor = MaterialShowcaseInstructionView.BACKGROUND_COLOR
      } else {
          // Fallback on earlier versions
      }
    
    layer.cornerRadius = cornerRadius
    layer.masksToBounds = false
   // addArrow()
  }
    private func addArrow() {
        arrowView?.removeFromSuperview()

        let arrowYOffset: CGFloat = arrowDirection == .up ? -arrowHeight + 1 : bounds.height - 1
        let arrowContainer = UIView(frame: CGRect(x: 0, y: arrowYOffset, width: arrowWidth, height: arrowHeight))
        arrowContainer.backgroundColor = .clear

        let arrowPath = UIBezierPath()

        if arrowDirection == .up {
            // ▲ Pointing up
            arrowPath.move(to: CGPoint(x: 0, y: arrowHeight)) // left base
            arrowPath.addLine(to: CGPoint(x: arrowWidth / 2, y: 0)) // tip
            arrowPath.addLine(to: CGPoint(x: arrowWidth, y: arrowHeight)) // right base
        } else {
            // ▼ Pointing down
            arrowPath.move(to: CGPoint(x: 0, y: 0)) // left base
            arrowPath.addLine(to: CGPoint(x: arrowWidth / 2, y: arrowHeight)) // tip
            arrowPath.addLine(to: CGPoint(x: arrowWidth, y: 0)) // right base
        }

        arrowPath.close()

        let mask = CAShapeLayer()
        mask.path = arrowPath.cgPath
        if #available(iOS 13.0, *) {
            mask.fillColor = MaterialShowcaseInstructionView.BACKGROUND_COLOR.cgColor
        } else {
            // Fallback on earlier versions
        }
        arrowContainer.layer.mask = mask
        if #available(iOS 13.0, *) {
            arrowContainer.backgroundColor = MaterialShowcaseInstructionView.BACKGROUND_COLOR
        } else {
            // Fallback on earlier versions
        }

        var arrowX: CGFloat
        switch arrowAlignment {
        case .left:
            arrowX = padding + arrowXOffset
        case .center:
            arrowX = (frame.width - arrowWidth) / 2 + arrowXOffset
        case .right:
            arrowX = frame.width - padding - arrowWidth + arrowXOffset
        }

        arrowContainer.frame.origin.x = arrowX
        addSubview(arrowContainer)
        arrowView = arrowContainer
    }


  private func setDefaultProperties() {
    // Text defaults
    primaryText = MaterialShowcaseInstructionView.PRIMARY_DEFAULT_TEXT
    secondaryText = MaterialShowcaseInstructionView.SECONDARY_DEFAULT_TEXT
    primaryTextColor = MaterialShowcaseInstructionView.PRIMARY_TEXT_COLOR
    secondaryTextColor = MaterialShowcaseInstructionView.SECONDARY_TEXT_COLOR
    primaryTextSize = MaterialShowcaseInstructionView.PRIMARY_TEXT_SIZE
    secondaryTextSize = MaterialShowcaseInstructionView.SECONDARY_TEXT_SIZE
  }
  
  /// Adds the primary label
  private func addPrimaryLabel() {
      if primaryLabel != nil {
          primaryLabel.removeFromSuperview()
      }

      // Create a container view for the image and label
  
      containerView.frame = CGRect(x: padding,
                                   y: padding,
                                   width: frame.width - 2 * padding,
                                   height: 0)

      // Add the image view
      let imageView = UIImageView()
      imageView.image = UIImage(named: "Vector (1)")
      imageView.contentMode = .scaleAspectFit

      let imageSize: CGFloat = 20 // Set the size of the image
      imageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)

      // Add the primary label
      primaryLabel = UILabel()
      primaryLabel.font = primaryTextFont ?? UIFont.boldSystemFont(ofSize: primaryTextSize)
      primaryLabel.textColor = primaryTextColor
      primaryLabel.textAlignment = primaryTextAlignment ?? .left
      primaryLabel.numberOfLines = 0
      primaryLabel.text = primaryText
      primaryLabel.frame = CGRect(x: imageView.frame.maxX + 8, // Add some spacing between the image and text
                                  y: 0,
                                  width: containerView.frame.width - (imageView.frame.width + 8),
                                  height: 0)
      primaryLabel.sizeToFit()

      // Adjust the container view height based on the tallest element
      containerView.frame.size.height = max(imageView.frame.height, primaryLabel.frame.height)

      // Add subviews to the container view
      containerView.addSubview(imageView)
      containerView.addSubview(primaryLabel)

      // Add the container view to the main view
      addSubview(containerView)
  }
  
  /// Adds the secondary label
  private func addSecondaryLabel() {
    if secondaryLabel != nil {
      secondaryLabel.removeFromSuperview()
    }
    secondaryLabel = UILabel()
    secondaryLabel.font = secondaryTextFont ?? UIFont.systemFont(ofSize: secondaryTextSize)
    secondaryLabel.textColor = secondaryTextColor
    secondaryLabel.textAlignment = secondaryTextAlignment ?? .left
    secondaryLabel.numberOfLines = 0
    secondaryLabel.text = secondaryText
    secondaryLabel.frame = CGRect(x: padding,
                                  y: containerView.frame.maxY + 8,
                                  width: frame.width - 2 * padding,
                                  height: 0)
    secondaryLabel.sizeToFit()
    addSubview(secondaryLabel)
  }
  
  /// Adds an arrow pointing to the target
//  private func addArrow() {
//    if arrowLayer != nil {
//      arrowLayer.removeFromSuperlayer()
//    }
//
//    arrowLayer = CAShapeLayer()
//    let arrowPath = UIBezierPath()
//    let arrowStartX = (frame.width - arrowWidth) / 2
//    let arrowStartY = frame.height
//
//    arrowPath.move(to: CGPoint(x: arrowStartX, y: arrowStartY))
//    arrowPath.addLine(to: CGPoint(x: arrowStartX + arrowWidth, y: arrowStartY))
//    arrowPath.addLine(to: CGPoint(x: arrowStartX + arrowWidth / 2, y: arrowStartY + arrowHeight))
//    arrowPath.close()
//
//    arrowLayer.path = arrowPath.cgPath
//    arrowLayer.fillColor = MaterialShowcaseInstructionView.BACKGROUND_COLOR.cgColor
//    layer.addSublayer(arrowLayer)
//  }
    func addNextBtn() {
        if nextBtn == nil {
            let nextBtn = UIButton()
            nextBtn.setTitle("Next", for: .normal)
            nextBtn.setTitleColor(UIColor.black, for: .normal)
            nextBtn.titleLabel?.font = .boldSystemFont(ofSize: 17)
            nextBtn.tintColor = UIColor.black
            nextBtn.addTarget(self, action: #selector(tapOnNextBtn), for: .touchUpInside)

            nextBtn.frame = CGRect(x: 8,
                                   y: primaryLabel.frame.maxY + secondaryLabel.frame.maxY - 10,
                                   width: 60,
                                   height: 30)

            self.nextBtn = nextBtn
            addSubview(nextBtn)
        }

       
                if let image = UIImage(named: "Icon") {
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = .scaleAspectFit
                    imageView.frame = CGRect(
                        x: 60,
                        y: (nextBtn?.frame.origin.y)! + 6 ,
                        width: 20,
                        height: 20
                    )
                    self.arrowImageView = imageView
                    addSubview(imageView)
                }
            
        

        print("Next button and image handled")
    }

    @objc func tapOnNextBtn() {
        print("Tap detected on next button")
        if let action = nextButtonAction {
            print("Executing nextButtonAction")
            action() // Invoke the action
        } else {
            print("nextButtonAction is nil")
        }
    }
    @objc func tapOnSkipBtn()
    {
        if let action = skipButtonAction {
            print("Executing nextButtonAction")
            action() // Invoke the action
        }
    }
    func addSkipBtn() {
        if let skipBtn = skipBtn {

    
        }
        else{
            let skipBtn = UIButton()
            skipBtn.setTitle("Skip guide", for: .normal)
            skipBtn.titleLabel?.font = .boldSystemFont(ofSize: 14)
            skipBtn.setTitleColor(UIColor.gray, for: .normal) // Ensure title color is visible
            skipBtn.frame = CGRect(x: containerView.frame.width - 60 , // Align to the right with padding
                                   y: primaryLabel.frame.maxY + secondaryLabel.frame.maxY - 10 , // Position below the labels
                                   width: 80, // Adjust width for text
                                   height: 30) // Adjust height for better visibility
            skipBtn.addTarget(self, action: #selector(tapOnSkipBtn), for: .touchUpInside)
            self.skipBtn = skipBtn
            addSubview(skipBtn)
        }

    }

    /// Lays out subviews and dynamically adjusts frame size
    public override func layoutSubviews() {
        super.layoutSubviews()

        if primaryLabel == nil { addPrimaryLabel() }
        if secondaryLabel == nil { addSecondaryLabel() }
        if nextBtn == nil { addNextBtn() }
        if skipBtn == nil { addSkipBtn() }

        // Adjust total height
        frame = CGRect(
            x: frame.minX,
            y: frame.minY,
            width: frame.width,
            height: primaryLabel.frame.height + secondaryLabel.frame.height + 2 * padding + 30 + arrowHeight + 5
        )

        addArrow() // Refresh arrow on layout
    }

}
public enum ArrowAlignment {
    case left
    case center
    case right
}
public enum ArrowDirection {
    case up   // arrow pointing upward (default)
    case down // arrow pointing downward
}
