//
//  PhotoItemView.swift
//  CashMore
//
//  Created by Tim on 2023/6/16.
//

import UIKit

class PhotoItemView: UIView {
    
    var image : UIImage? {
        didSet {
            photoView.image = image
        }
    }
    
    var imageUrl : String? {
        didSet {
            if let url = imageUrl {
                photoView.kf.setImage(with: URL(string: url)!)
            }
        }
    }
    
    convenience init(showsDeleteBtn: Bool = true, tag: Int = 0, deleteBtnAction: ((Int) -> Void)? = nil) {
        self.init(frame: .zero)
        self.delBtn.isHidden = !showsDeleteBtn
        self.tag = tag
        self.deleteAction = deleteBtnAction
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoView)
        addSubview(delBtn)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        delBtn.snp.makeConstraints { make in
            make.top.equalTo(1)
            make.right.equalTo(-1)
            make.size.equalTo(CGSize(width: 22, height: 22))
        }
    }

    private lazy var photoView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var delBtn = {
        let btn = UIButton(type: .custom)
        btn.setImage(R.image.del_picture(), for: .normal)
        btn.addTarget(self, action: #selector(delBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    private var deleteAction : ((_ tag: Int) -> Void)?
}

extension PhotoItemView {
    @objc func delBtnClicked() {
        deleteAction?(self.tag)
    }
}
