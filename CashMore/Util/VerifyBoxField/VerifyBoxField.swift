//
//  VerifyBoxField.swift
//  VerifyBoxField
//
//  Created by Tim on 2023/6/3.
//

import UIKit
import SnapKit


enum VerifyBoxFieldStyle {
    case border
    case underline
}

extension Notification.Name {
    fileprivate static let verifyBoxFieldDidBecomeFirstResponderNotification = Notification.Name("VerifyBoxieldDidBecomeFirstResponderNotification")
    fileprivate static let verifyBoxFieldDidResignFirstResponderNotification = Notification.Name("VerifyBoxFieldDidResignFirstResponderNotification")
}

protocol VerifyBoxFieldDelegate {
    func verifyBoxField(_ verifyBoxField: VerifyBoxField, sholdChangeCharactersInRange range: Range<Int>, replacementString string: String) -> Bool
}

extension VerifyBoxFieldDelegate {
    func verifyBoxField(_ verifyBoxField: VerifyBoxField, sholdChangeCharactersInRange range: Range<Int>, replacementString string: String) -> Bool {true}
}

class VerifyBoxField: UIControl {
    var delegate: VerifyBoxFieldDelegate?
    var shouldChangeCharacters: ((_ range: Range<Int>, _ string: String) -> Bool)?


    // MARK: - UITextInput
    var selectedTextRange : UITextRange?
    var markedTextStyle   : [NSAttributedString.Key : Any]?
    var markedTextRange   : UITextRange? = nil
    var inputDelegate     : UITextInputDelegate?
    lazy var tokenizer    : UITextInputTokenizer = UITextInputStringTokenizer(textInput: self)

    // UITextInputTraits
    var isSecureTextEntry : Bool = false {
        didSet {
            resetCursorStateIfNeeded()
        }
    }

    var textContentType: UITextContentType? {
        get {
            return _textContentType
        }

        set {
            _textContentType = newValue
        }
    }

    var keyboardType : UIKeyboardType = .numberPad
    var returnKeyType: UIReturnKeyType = .done
    var enablesReturnKeyAutomatically : Bool = true
    var autocorrectionType : UITextAutocorrectionType = .no
    var autocapitalizationType : UITextAutocapitalizationType = .none

    var text : String? {
        get {
            guard characters.count > 0 else {
                return nil
            }
            return String(characters)
        }
        set {
            characters.removeAll()
            newValue?.forEach({ character in
                if self.characters.count < allowInputCount {
                    characters.append(character)
                }
            })
            setNeedsDisplay()
            resetCursorStateIfNeeded()

            if characters.count >= allowInputCount {
                if autoResignFirstResponseWhenInputFinished {
                    OperationQueue.main.addOperation {
                        _ = self.resignFirstResponder()
                    }
                }
            }
        }
    }

    // MARK: - Styles configuretion properties

    ///  verify code length limit, default is 6, region 1 ~ 8
    var allowInputCount : UInt = 6 {
        didSet {
            if allowInputCount > 8 || allowInputCount < 1 {
                allowInputCount = oldValue
                return
            }

            resetCursorStateIfNeeded()
        }
    }

    /// default style is VerifyBoxFieldStyleBorder
    var style : VerifyBoxFieldStyle = .border

    /// The spacing between each unit
    var itemSpace: CGFloat = 12 {
        didSet {
            if itemSpace < 2 {
                itemSpace = 0
            }

            resize()
            resetCursorStateIfNeeded()
        }
    }

    var borderRadius : CGFloat = 4 {
        didSet {
            if (borderRadius < 0) {
                borderRadius = oldValue
                return
            }
            resetCursorStateIfNeeded()
        }
    }

    /// width for border, default is 1
    var borderWidth : CGFloat = 1 {
        didSet {
            if (borderWidth < 0) {
                borderWidth = oldValue
                return
            }
            resetCursorStateIfNeeded()
        }
    }

    var textFont : UIFont = UIFont.systemFont(ofSize: 22) {
        didSet {
            resetCursorStateIfNeeded()
        }
    }

    /// text color, default is UIColor.darkGray
    var textColor : UIColor = .darkGray {
        didSet {
            resetCursorStateIfNeeded()
        }
    }

    /// If you need to specify the completed unit color explicitly after completing a unit input, you can set this property. The default is nil.
    /// Tip: This attribute is valid only when the value of the `itemSpace` attribute is greater than 2. In continuous mode, color tracking is not suitable. You can consider using `cursorColor` instead
    var trackTintColor : UIColor? = .orange {
        didSet {
            resetCursorStateIfNeeded()
        }
    }

    /// Used to prompt for the location of the focus for input, setting this value will produce a cursor flicker animation, if set to empty, no cursor animation will be generated.
    var cursorColor : UIColor? = .orange {
        didSet {
            cursorLayer.backgroundColor = cursorColor?.cgColor
            resetCursorStateIfNeeded()
        }
    }

    /// default is #F74C31
    var tipErrorColor : UIColor = UIColor(red: 247.0 / 255.0, green: 76 / 255.0, blue: 49 / 255.0, alpha: 1)

    /// auto resign first response, default is false
    var autoResignFirstResponseWhenInputFinished : Bool = false

    /// each item size, default is 44 x 44
    var itemSize : CGSize = CGSize(width: 44, height: 44) {
        didSet {
            resetCursorStateIfNeeded()
        }
    }

    /// background color for item
    var itemBackgroundColor : UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    override var backgroundColor: UIColor? {
        didSet {
            super.backgroundColor = backgroundColor
            resetCursorStateIfNeeded()
        }
    }


    override var tintColor: UIColor! {
        didSet {
            super.tintColor = tintColor
            resetCursorStateIfNeeded()
        }
    }




    // MARK: - private properties
    private lazy var _textContentType : UITextContentType? = {
        if #available(iOS 12.0, *) {
            return .oneTimeCode
        } else {
            return nil
        }
    }()

    private var characters = [Character]()

    private let cursorLayer : CALayer = {
        let layer = CALayer()
        layer.isHidden = true
        layer.opacity  = 1

        let animate = CABasicAnimation(keyPath: "opacity")
        animate.fromValue = 0
        animate.toValue   = 1.5
        animate.duration  = 0.5
        animate.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animate.autoreverses = true
        animate.isRemovedOnCompletion = false
        animate.fillMode = .forwards
        animate.repeatCount = .greatestFiniteMagnitude
        layer.add(animate, forKey: nil)
        return layer
    }()

    var mCtx : CGContext?
    var mMarkedText : String? = nil
    var borderLineViews = [UIView]()

    // MARK: - initialize
    convenience init(allowInputCount count: UInt) {
        self.init(style: .border, allowInputCount: count)
    }

    init(style: VerifyBoxFieldStyle, allowInputCount count: UInt) {
        assert(count > 0, "VerifyBoxField must have one or more input units.")
        assert(count <= 8, "VerifyBoxField can not have more than 8 input units.")
        self.style = style
        self.allowInputCount = count

        super.init(frame: .zero)
        initialize()
        resetCursorStateIfNeeded()
    }

    required public init?(coder: NSCoder) {
        allowInputCount = 4
        style = .border
        super.init(coder: coder)
        initialize()
    }

    func initialize() {
        backgroundColor = .clear

        tintColor = .lightGray
        cursorLayer.backgroundColor = cursorColor?.cgColor

        let point = VerifyBoxFieldTextPosition(offset: 0)
        let aNewRange = VerifyBoxFieldTextRange(start: point, end: point)
        selectedTextRange = aNewRange

        layer.addSublayer(cursorLayer)

        OperationQueue.main.addOperation {
            self.layoutIfNeeded()
            self.cursorLayer.position = CGPoint(x: self.bounds.width / CGFloat(self.allowInputCount) / 2, y: self.bounds.height / 2)
        }

        setNeedsDisplay()

        var preLineView : UIView?
        (0 ..< allowInputCount).forEach { index in
            let lineView = UIView()
            lineView.backgroundColor = tintColor
            addSubview(lineView)
            
            lineView.snp.makeConstraints {
                if index == 0 {
                    $0.left.equalToSuperview()
                }

                if index == (allowInputCount - 1) {
                    $0.right.equalToSuperview()
                }

                $0.bottom.equalToSuperview()
                $0.height.equalTo(2)

                if let p = preLineView {
                    $0.left.equalTo(p.snp.right).offset(itemSpace)
                    $0.width.equalTo(p)
                }
            }
            borderLineViews.append(lineView)
            preLineView = lineView
        }
    }
    
    var isCodeError : Bool = false
    
    func tipLoading() {
        borderLineViews.enumerated().forEach {
            $1.layer.removeAllAnimations()
            switch ($0 % 3) {
            case 0:
                loadingAnimation(layer: $1.layer, values: [1, 0.4, 1])
            case 1:
                loadingAnimation(layer: $1.layer, values: [0.7, 0.4, 1, 0.7])
            default:
                loadingAnimation(layer: $1.layer, values: [0.4, 1, 0.4])
            }
        }
    }
    
    func stopLoading() {
        borderLineViews.forEach {
            $0.layer.removeAnimation(forKey: loadingAnimationKey)
        }
    }
    
    func tipError() {
        if allowInputCount == (text?.count ?? 0) {
            isCodeError = true
            self.setNeedsDisplay()
            borderLineViews.forEach {
                $0.layer.removeAnimation(forKey: loadingAnimationKey)
                shakeAnimation(layer: $0.layer)
            }
        }
    }
    
    let loadingAnimationKey = "loadingAnimationKey"
    
    private func loadingAnimation(layer: CALayer, values: [Any]?) {
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.values = values
        animation.autoreverses = true
        animation.duration = 0.8
        animation.repeatCount = MAXFLOAT
        layer.add(animation, forKey: loadingAnimationKey)
    }
    
    private func shakeAnimation(layer: CALayer) {
        let position = layer.position
        let x = CGPoint(x: position.x + 10, y: position.y)
        let y = CGPoint(x: position.x - 10, y: position.y)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fromValue = x
        animation.toValue = y
        animation.autoreverses = true
        animation.duration = 0.04
        animation.repeatCount = 4
        layer.add(animation, forKey: nil)
    }
    
    
    // MARK: - Event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        _ = becomeFirstResponder()
    }
    
    // MARK: - Override
    override var intrinsicContentSize: CGSize {
        let width = Int(allowInputCount) * (Int(itemSize.width) + Int(itemSpace)) - Int(itemSpace)
        let height = Int(itemSize.height)
        return CGSize(width: width, height: height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return intrinsicContentSize
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        resetCursorStateIfNeeded()
        
        if result {
            sendActions(for: .editingDidBegin)
            NotificationCenter.default.post(name: .verifyBoxFieldDidBecomeFirstResponderNotification, object: self)
        }
        return result
    }
    
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        resetCursorStateIfNeeded()
        if result {
            sendActions(for: .editingDidEnd)
            NotificationCenter.default.post(name: .verifyBoxFieldDidResignFirstResponderNotification, object: self)
        }
        return result
    }
    
    override func draw(_ rect: CGRect) {
        
        // The lines drawn have width, so you need to consider the impact of this factor on the drawing effect when drawing.
        let width = (rect.size.width + CGFloat(itemSpace)) / CGFloat(allowInputCount) - itemSpace
        let height = rect.size.height
        let unitSize = CGSize(width: width, height: height)
        mCtx = UIGraphicsGetCurrentContext()
        
        fill(rect: rect, itemSize: unitSize)
        drawBorder(rect: rect, itemSize: unitSize)
        drawText(rect: rect, itemSize: unitSize)
        drawTrackBorder(rect: rect, itemSize: unitSize)
    }

    /// Reassign the inherent size of the control itself in the AutoLayout environment
    func resize() {
        invalidateIntrinsicContentSize()
    }
    
    
    /// draw the background color and clip the drawing area
    /// - Parameters:
    ///   - rect: The area drawn by the
    private func fill(rect: CGRect, itemSize: CGSize) {
        guard let color = itemBackgroundColor else {
            return
        }
        
        let radius = style == .border ? borderRadius : 0
        
        if (itemSpace < 2) {
            let bezierPath = UIBezierPath(roundedRect: rect, cornerRadius: radius)
            mCtx?.addPath(bezierPath.cgPath)
        } else {
            for i in 0 ..< allowInputCount {
                var unitRect = CGRect(x: CGFloat(i) * (itemSize.width + CGFloat(itemSpace)),
                                      y: 0,
                                      width: itemSize.width,
                                      height: itemSize.height)
                unitRect = unitRect.insetBy(dx: borderWidth * 0.5,
                                            dy: borderWidth * 0.5)
                let bezierPath = UIBezierPath(roundedRect: unitRect, cornerRadius: radius)
                mCtx?.addPath(bezierPath.cgPath)
            }
        }
        mCtx?.setFillColor(color.cgColor)
        mCtx?.fillPath()
    }
    
    
    /// drawing the item border
    /// - Parameters:
    ///   - rect: The area drawn by the
    private func drawBorder(rect: CGRect, itemSize: CGSize) {
        
        if style == .border {
            tintColor.setStroke()
            mCtx?.setLineWidth(borderWidth)
            mCtx?.setLineCap(.round)
            if itemSpace < 2 {
                let bounds = rect.insetBy(dx: borderWidth * 0.5, dy: borderWidth * 0.5)
                let bezierPath = UIBezierPath(roundedRect: bounds, cornerRadius: borderRadius)
                mCtx?.addPath(bezierPath.cgPath)
                (1 ..< allowInputCount).forEach {
                    mCtx?.move(to: CGPoint(x: (CGFloat($0) * itemSize.width), y: 0))
                    mCtx?.addLine(to: CGPoint(x: CGFloat($0) * itemSize.width, y: itemSize.height))
                }
            } else {
                (UInt(characters.count) ..< allowInputCount).forEach {
                    var unitRect = CGRect(x: CGFloat($0) * (itemSize.width + itemSpace), y: 0, width: itemSize.width, height: itemSize.height)
                    unitRect = unitRect.insetBy(dx: borderWidth * 0.5, dy: borderWidth * 0.5)
                    let bezierPath = UIBezierPath(roundedRect: unitRect, cornerRadius: borderRadius)
                    mCtx?.addPath(bezierPath.cgPath)
                }
            }
            
            mCtx?.drawPath(using: .stroke)
        } else {
            (UInt(characters.count) ..< self.allowInputCount).forEach {
                borderLineViews[Int($0)].backgroundColor = tintColor
            }
        }
    }
    
    
    /// drawing the tracking border
    /// - Parameters:
    ///   - rect: The area drawn by the
    private func drawTrackBorder(rect: CGRect, itemSize: CGSize) {
        
        guard let color = isCodeError ? tipErrorColor : trackTintColor else {
            return
        }
        
        if style == .border {
            guard itemSpace > 1 else {
                return
            }
            color.setStroke()
            mCtx?.setLineWidth(borderWidth)
            mCtx?.setLineCap(.round)
            (0..<characters.count).forEach {
                var itemRect = CGRect(x: CGFloat($0) * (itemSize.width + itemSpace), y: 0, width: itemSize.width, height: itemSize.height)
                itemRect = itemRect.insetBy(dx: borderWidth * 0.5, dy: borderWidth * 0.5)
                let bezierPath = UIBezierPath(roundedRect: itemRect, cornerRadius: borderRadius)
                mCtx?.addPath(bezierPath.cgPath)
            }
            mCtx?.drawPath(using: .stroke)
        } else {
            (0..<characters.count).forEach {
                borderLineViews[Int($0)].backgroundColor = color
            }
        }
    }
    
    /// drawing the text
    /// - Parameters:
    ///   - rect: The area drawn by the
    private func drawText(rect: CGRect, itemSize: CGSize) {

        guard hasText else {
            return
        }
        
        
        let attr = [NSAttributedString.Key.foregroundColor: textColor,
                    NSAttributedString.Key.font: textFont]
        
        for i in 0 ..< characters.count {
            let unitRect = CGRect(x: CGFloat(i) * (itemSize.width + itemSpace), y: 0, width: itemSize.width, height: itemSize.height)
            
            let yOffset = style == .border ? 0 : borderWidth
            
            if isSecureTextEntry {
                var drawRect = unitRect.insetBy(dx: (unitRect.size.width - textFont.pointSize / 2) / 2,
                                                dy: (unitRect.size.height - textFont.pointSize / 2) / 2)
                drawRect.size.height -= yOffset
                textColor.setFill()
                mCtx?.addEllipse(in: drawRect)
                mCtx?.fillPath()
            } else {
                let subString = NSString(string: String(characters[i]))
                
                let oneTextSize = subString.size(withAttributes: attr)
                var drawRect = unitRect.insetBy(dx: (unitRect.size.width - oneTextSize.width) / 2,
                                                dy: (unitRect.size.height - oneTextSize.height) / 2)
                
                drawRect.size.height -= yOffset
                subString.draw(in: drawRect, withAttributes: attr)
            }
        }
    }
    

    func resetCursorStateIfNeeded() {
        DispatchQueue.main.async {
            self.cursorLayer.isHidden = !self.isFirstResponder || self.allowInputCount == self.characters.count || self.cursorColor == nil
            if self.cursorLayer.isHidden {
                return
            }

            let itemWidth = (self.bounds.size.width + CGFloat(self.itemSpace)) / CGFloat(self.allowInputCount) - CGFloat(self.itemSpace)
            let itemHeight = self.bounds.size.height

            var itemRect = CGRect(x: CGFloat(self.characters.count) * (itemWidth + CGFloat(self.itemSpace)),
                                  y: 0,
                                  width: itemWidth,
                                  height: itemHeight)
            itemRect = itemRect.insetBy(dx: itemWidth / 2 - 1,
                                        dy: (itemRect.size.height - self.textFont.pointSize) / 2)

            let yOffset = self.style == .border ? 0 : self.borderWidth
            itemRect.size.height -= yOffset
            CATransaction.begin()
            CATransaction.setDisableActions(false)
            CATransaction.setAnimationDuration(0)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
            self.cursorLayer.frame = itemRect
            CATransaction.commit()
        }
    }
}

// MARK: - VerifyBoxField Implement
extension VerifyBoxField : UITextInput {
    func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    func deleteBackward() {
        guard hasText else {
            return
        }
        isCodeError = false
        inputDelegate?.textWillChange(self)
        characters.removeLast()
        sendActions(for: .editingChanged)
        setNeedsDisplay()
        
        resetCursorStateIfNeeded()
        inputDelegate?.textDidChange(self)
    }
    
    func replace(_ range: UITextRange, withText text: String) {
        
    }
    
    // selectedRange is a range within the markedText
    func setMarkedText(_ markedText: String?, selectedRange: NSRange) {
        mMarkedText = markedText
    }
    
    func unmarkText() {
        if (text?.count ?? 0) >= allowInputCount {
            mMarkedText = nil
            return
        }
        if mMarkedText != nil {
            insertText(mMarkedText!)
            mMarkedText = nil
        }
    }
    
    var beginningOfDocument: UITextPosition {
        return VerifyBoxFieldTextPosition(offset: 0)
    }
    
    var endOfDocument: UITextPosition {
        guard let text = self.text, text.count > 0 else {
            return VerifyBoxFieldTextPosition(offset: 0)
        }
        return VerifyBoxFieldTextPosition(offset: text.count - 1)
    }
    
    func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
        guard let fromPosition = fromPosition as? VerifyBoxFieldTextPosition, let toPosition = toPosition as? VerifyBoxFieldTextPosition  else {
            return nil
        }
        let location = Int(min(fromPosition.offset, toPosition.offset))
        let length = Int(abs(toPosition.offset - fromPosition.offset))
        let range = NSRange(location: location, length: length)
        return VerifyBoxFieldTextRange(range: range)
    }
    
    func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
        guard let position = position as? VerifyBoxFieldTextPosition else {
            return nil
        }
        let end = position.offset + offset
        if (end > (self.text?.count ?? 0) || end < 0) {
            return nil
        }
        return VerifyBoxFieldTextPosition(offset: end)
    }
    
    func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
        guard let position = position as? VerifyBoxFieldTextPosition else {
            return UITextPosition()
        }
        return VerifyBoxFieldTextPosition(offset: position.offset + offset)
    }
    
    func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult {
        guard let position = position as? VerifyBoxFieldTextPosition, let other = other as? VerifyBoxFieldTextPosition  else {
            return .orderedSame
        }
        if position.offset < other.offset {
            return .orderedAscending
        }
        if position.offset > other.offset {
            return .orderedDescending
        }
        return .orderedSame;
    }
    
    func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int {
        guard let from = from as? VerifyBoxFieldTextPosition, let toPosition = toPosition as? VerifyBoxFieldTextPosition  else {
            return 0
        }
        return Int(toPosition.offset - from.offset)
    }
    
    func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? {
        return nil
    }
    
    func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? {
        return nil
    }
    
    
    func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> NSWritingDirection {
        return .natural
    }
    
    func setBaseWritingDirection(_ writingDirection: NSWritingDirection, for range: UITextRange) {
        
    }
    
    func firstRect(for range: UITextRange) -> CGRect {
        .null
    }
    
    func caretRect(for position: UITextPosition) -> CGRect {
        .null
    }
    
    
    func closestPosition(to point: CGPoint) -> UITextPosition? {
       return nil
    }
   
    func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? {
        return nil
    }
    
    func characterRange(at point: CGPoint) -> UITextRange? {
        return nil
    }
    
    func text(in range: UITextRange) -> String? {
        return self.text
    }
    
    var hasText: Bool {
        return characters.count > 0;
    }
    
    func insertText(_ text: String) {
        guard text != "\n" else {
            _ = resignFirstResponder()
            return
        }
        
        guard text != " " else {
            return
        }
        isCodeError = false
        guard characters.count < allowInputCount else {
            
            if autoResignFirstResponseWhenInputFinished {
                _ = resignFirstResponder()
            }
            return
        }
        let lower = self.text?.count ?? 0
        let upper = lower + text.count
        let range = Range<Int>(uncheckedBounds: (lower: lower, upper: upper))
        
        guard delegate?.verifyBoxField(self, sholdChangeCharactersInRange: range, replacementString: text) ?? true else {
            return
        }
        
        guard self.shouldChangeCharacters?(range, text) ?? true else {
            return
        }
        
        inputDelegate?.textWillChange(self)
        
        text.forEach { (character) in
            characters.append(character)
        }
        
        if characters.count >= allowInputCount {
            characters.removeSubrange(characters.index(0, offsetBy: Int(allowInputCount)) ..< characters.endIndex)
            if autoResignFirstResponseWhenInputFinished {
                OperationQueue.main.addOperation {
                    _ = self.resignFirstResponder()
                }
            }
        }
        
        sendActions(for: .editingChanged)
        setNeedsDisplay()
        resetCursorStateIfNeeded()
        inputDelegate?.textDidChange(self)
    }
}
