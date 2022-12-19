//
//  CustomSegmentedControl.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import UIKit

protocol CustomSegmentedControlDelegate:AnyObject {
    func change(to index:Int)
}

class CustomSegmentedControl: UIView {
   // can be customized
    var textColor:UIColor = UIColor.black
    var selectorViewColor: UIColor = .blue
    var selectorTextColor: UIColor = .blue
    var textFont: UIFont = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium, maxSize: 13)
    var selectorTextFont: UIFont = UIFont.preferredFont(forTextStyle: .footnote, weight: .bold, maxSize: 13)
    var isVertical: Bool = false
    var isUnderline: Bool = true
    var spacing = 0.0 

    private var buttonTitles = [String]()
    private var buttonIcons = [UIImage?]()
    private var buttons = [UIButton]()
    private var selectorView: UIView!
    private let defaultVerticalHeight: CGFloat = 60.0

    weak var delegate:CustomSegmentedControlDelegate?

    public private(set) var selectedIndex : Int = 0

   convenience init(frame:CGRect, buttonTitle:[String], buttonIcons:[UIImage?] = [], isVertical:Bool = false) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
        self.buttonIcons = buttonIcons
        self.isVertical = isVertical
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
        updateView()
    }

    func setButtonTitles(buttonTitles:[String], isVertical:Bool = false) {
        self.buttonTitles = buttonTitles
        self.isVertical = isVertical
        self.updateView()
    }

    func setButtonIcons(buttonIcons:[UIImage?]) {
      self.buttonIcons = buttonIcons
      self.updateView()
    }

    func getCount() -> Int{
        return buttons.count
    }

    func setIndex(index:Int) {
       moveSelectorView(changedToIndex: index)
    }

    private func moveSelectorView(changedToIndex index: Int){
        for button in buttons {
           button.tintColor = textColor
           button.titleLabel?.font = textFont

           if button.tag == index {
               selectedIndex = index
               delegate?.change(to: selectedIndex)
               if isVertical {
                  var selectorHeight: CGFloat = defaultVerticalHeight
                  if frame.height / CGFloat(self.buttonTitles.count) < defaultVerticalHeight {
                     selectorHeight = frame.height / CGFloat(self.buttonTitles.count)
                  }
                  let selectorPosition = selectorHeight * CGFloat(index)
                  UIView.animate(withDuration: 0.3) {
                     self.selectorView.frame.origin.y = selectorPosition
                  }
               } else {
                  let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
                  UIView.animate(withDuration: 0.3) {
                     self.selectorView.frame.origin.x = selectorPosition
                  }
               }

               button.tintColor = selectorTextColor
               button.titleLabel?.font = selectorTextFont
            }
        }
    }

    @objc func buttonAction(sender:UIButton) {
       moveSelectorView(changedToIndex: sender.tag)
    }
}

//Configuration View
extension CustomSegmentedControl {
   private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }

   private func createButton() {
      // cleanup
       buttons.removeAll()
       subviews.forEach({$0.removeFromSuperview()})

      // create a button for every title
       for (index, buttonTitle) in buttonTitles.enumerated() {
           let button = UIButton(type: .system)
           button.setTitle(buttonTitle, for: .normal)

          // if vertical, set the height to min 60 or equal height based on number of buttons
           if isVertical {
             button.contentHorizontalAlignment = .left
             button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 24.0, bottom: 0.0, right: 0.0)
             var buttonHeight: CGFloat = defaultVerticalHeight
             if frame.height / CGFloat(self.buttonTitles.count) < defaultVerticalHeight {
                buttonHeight = frame.height / CGFloat(self.buttonTitles.count)
             }
             button.frame.size.height = buttonHeight
           }

          // add image to the button if images exist
            if buttonIcons.count > index {
              if let image = buttonIcons[index] {
                 button.setImage(image, for: .normal)
                 button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
              }
           }
           button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
           button.tintColor = textColor
           button.titleLabel?.font = textFont
           button.tag = buttons.count
           buttons.append(button)
       }

      // set first image as selected
       if !buttons.isEmpty {
          buttons[0].tintColor = selectorTextColor
          buttons[0].titleLabel?.font = selectorTextFont
       }
   }

    private func configStackView() {
       // create stack view with newly created button array
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = isVertical ? .vertical : .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = spacing
        addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

       // vertical needs height constraint, horizontal needs bottom constraint
        if isVertical {
           var buttonHeight: CGFloat = defaultVerticalHeight
           if frame.height / CGFloat(self.buttonTitles.count) < defaultVerticalHeight {
              buttonHeight = frame.height / CGFloat(self.buttonTitles.count)
           }
           let height = buttonHeight * CGFloat(self.buttonTitles.count)
           stack.heightAnchor.constraint(equalToConstant: height).isActive = true
        } else {
           stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }

    private func configSelectorView() {
        if isVertical {
           var selectorHeight: CGFloat = defaultVerticalHeight
           if frame.height / CGFloat(self.buttonTitles.count) < defaultVerticalHeight {
              selectorHeight = frame.height / CGFloat(self.buttonTitles.count)
           }
           let selectorWidth = isUnderline ? 1.0 : frame.width
           selectorView = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: selectorHeight))
        } else {
           let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
           let selectorHeight = isUnderline ? 1.0 : frame.height
           let posY = isUnderline ? frame.height : 0
           selectorView = UIView(frame: CGRect(x: 0, y: posY, width: selectorWidth, height: selectorHeight))
        }

        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
        selectorView.roundCorners([.topLeft, .topRight], radius: 9.0)
    }
}


