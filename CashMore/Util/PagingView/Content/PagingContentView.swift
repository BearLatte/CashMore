//
//  PagingContentView.swift
//  CashMore
//
//  Created by Tim on 2023/6/6.
//

import UIKit

@objc protocol PagingContentViewDelegate {
    @objc optional func pagingContentView(contentView: PagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int)
    @objc optional func pagingContentView(index: Int)
    @objc optional func pagingContentViewDidScroll()
    @objc optional func pagingContentViewWillBeginDragging()
    @objc optional func pagingContentViewDidEndDecelerating()
}

class PagingContentView : UIView {
    weak var delegate : PagingContentViewDelegate?
    var isAnimated: Bool = false
    var isScrollEnable: Bool = true
    var isBounces: Bool = false
    func setPagingContentView(index: Int){}
}
