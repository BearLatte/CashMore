//
//  PagingContentScrollView.swift
//  CashMore
//
//  Created by Tim on 2023/6/6.
//

import UIKit

class PagingContentScrollView : PagingContentView {
    init(frame: CGRect, parentVC: UIViewController, childVCs: [UIViewController]) {
        super.init(frame: frame)
        
        parentViewController = parentVC
        childViewControllers = childVCs
        
        addSubview(scrollView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isScrollEnable: Bool {
        willSet {
            scrollView.isScrollEnabled = newValue
        }
    }
    
    override var isBounces: Bool {
        willSet {
            scrollView.bounces = newValue
        }
    }
    
    override func setPagingContentView(index: Int) {
        setPagingContentScrollView(index: index)
    }
    
    
    // MARK: - private
    private weak var parentViewController: UIViewController?
    private var childViewControllers: [UIViewController] = []
    private var startOffsetX: CGFloat = 0.0
    private var previousChildVC: UIViewController?
    private var previousChildVCIndex: Int = -1
    private var scroll: Bool = false
    
    private lazy var scrollView: UIScrollView = {
        let tempScrollView = UIScrollView()
        tempScrollView.frame = bounds
        tempScrollView.bounces = isBounces
        tempScrollView.delegate = self
        tempScrollView.isPagingEnabled = true
        tempScrollView.showsVerticalScrollIndicator = false
        tempScrollView.showsHorizontalScrollIndicator = false
        let contentWidth: CGFloat = CGFloat(childViewControllers.count) * tempScrollView.frame.size.width
        tempScrollView.contentSize = CGSize(width: contentWidth, height: 0)
        return tempScrollView
    }()
}

extension PagingContentScrollView {
    func setPagingContentScrollView(index: Int) {
        let offsetX = CGFloat(index) * scrollView.frame.size.width
        if previousChildVC != nil && previousChildVCIndex != index {
            previousChildVC?.beginAppearanceTransition(false, animated: false)
        }
        
        if previousChildVCIndex != index {
            let childVC: UIViewController = childViewControllers[index]
            var firstAdd = false
            if !(parentViewController?.children.contains(childVC))! {
                parentViewController?.addChild(childVC)
                firstAdd = true
            }
            childVC.beginAppearanceTransition(true, animated: false)
            
            if (firstAdd) {
                scrollView.addSubview(childVC.view)
                childVC.view.frame = CGRect(x: offsetX, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
            }
            
            if previousChildVC != nil && previousChildVCIndex != index {
                previousChildVC?.endAppearanceTransition()
            }
            childVC.endAppearanceTransition()
            
            if (firstAdd) {
                childVC.didMove(toParent: parentViewController)
            }
            
            previousChildVC = childVC
            
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: isAnimated)
        }
        
        previousChildVCIndex = index
        startOffsetX = offsetX
        
        delegate?.pagingContentView?(index: index)
        
//        if delegate != nil && ((delegate?.responds(to: #selector(delegate?.pagingContentView(index:)))) != nil) {
//            delegate?.pagingContentView?(index: index)
//        }
    }
}

extension PagingContentScrollView : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
        scroll = true
        delegate?.pagingContentViewWillBeginDragging?()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scroll = false
        let offsetX: CGFloat = scrollView.contentOffset.x
        if startOffsetX != offsetX {
            previousChildVC?.beginAppearanceTransition(false, animated: false)
        }
        let index: Int = Int(offsetX / scrollView.frame.size.width)
        let childVC: UIViewController = childViewControllers[index]
        var firstAdd = false
        if !(parentViewController?.children.contains(childVC))! {
            parentViewController?.addChild(childVC)
            firstAdd = true
        }
       
        childVC.beginAppearanceTransition(true, animated: false)
       
        if (firstAdd) {
            scrollView.addSubview(childVC.view)
            childVC.view.frame = CGRect(x: offsetX, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        }
        
        if startOffsetX != offsetX {
            previousChildVC?.endAppearanceTransition()
        }
        childVC.endAppearanceTransition()
       
        if (firstAdd) {
            childVC.didMove(toParent: parentViewController)
        }
        
        previousChildVC = childVC
        previousChildVCIndex = index
        
        delegate?.pagingContentView?(index: index)
//        if delegate != nil && ((delegate?.responds(to: #selector(delegate?.pagingContentView(index:)))) != nil) {
//
//        }
        
        delegate?.pagingContentViewDidEndDecelerating?()
//        if delegate != nil && ((delegate?.responds(to: #selector(delegate?.pagingContentViewDidEndDecelerating))) != nil) {
//
//        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        delegate?.pagingContentViewDidScroll?()
//        if delegate != nil && ((delegate?.responds(to: #selector(delegate?.pagingContentViewDidScroll))) != nil) {
//
//        }
        
        if isAnimated == true && scroll == false { return }
        
        var progress: CGFloat = 0.0
        var originalIndex: Int = 0
        var targetIndex: Int = 0
        
        let currentOffsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewW: CGFloat = scrollView.bounds.size.width
        if currentOffsetX > startOffsetX {
            if currentOffsetX > CGFloat(childViewControllers.count - 1) *  scrollViewW && isBounces == true {
                return
            }
            // 1、计算 progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
            // 2、计算 originalIndex
            originalIndex = Int(currentOffsetX / scrollViewW);
            // 3、计算 targetIndex
            targetIndex = originalIndex + 1;
            if targetIndex >= childViewControllers.count {
                progress = 1;
                targetIndex = originalIndex;
            }
            // 4、如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1;
                targetIndex = originalIndex;
            }
        } else {
            if currentOffsetX < 0 && isBounces == true {
                return
            }
            // 1、计算 progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
            // 2、计算 targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW);
            // 3、计算 originalIndex
            originalIndex = targetIndex + 1;
            if originalIndex >= childViewControllers.count {
                originalIndex = childViewControllers.count - 1;
            }
        }
        
        delegate?.pagingContentView?(contentView: self, progress: progress, currentIndex: originalIndex, targetIndex: targetIndex)
//        // 3、将 progress／currentIndex／targetIndex 传递给 PagingTitleView
//        if delegate != nil && ((delegate?.responds(to: #selector(delegate?.pagingContentView(contentView:progress:currentIndex:targetIndex:)))) != nil) {
//
//        }
    }
}
