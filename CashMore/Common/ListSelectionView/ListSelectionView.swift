//
//  ListSelectionView.swift
//  CashMore
//
//  Created by Tim on 2023/6/10.
//

import UIKit

class ListSelectionView : UIView {
    typealias SelectionableModel = Selectionable
    var content : [SelectionableModel] = []
    
    @discardableResult
    convenience init(title: String? = nil, showsTitleView: Bool = true, unselectedIndicatorText: String, contentList: [SelectionableModel], selectedAction: ((SelectionableModel) -> Void)?) {
        self.init(frame: UIScreen.main.bounds)
        self.content = contentList
        self.titleLabel.text = title
        self.titleLabel.isHidden = !showsTitleView
        self.titleDivider.isHidden = !showsTitleView
        self.showsTitleView = showsTitleView
        self.selectedAction = selectedAction
        self.unselectedIndicatorText = unselectedIndicatorText
        self.show()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.48)
        addSubview(bgView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(titleDivider)
        bgView.addSubview(listView)
        bgView.addSubview(okBtn)
        bgView.addSubview(doneBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: Constants.screenWidth * 0.8, height: 400))
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        titleDivider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        okBtn.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(bgView.snp.centerX).offset(-5)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        doneBtn.snp.makeConstraints { make in
            make.left.equalTo(bgView.snp.centerX).offset(5)
            make.right.equalTo(-10)
            make.height.bottom.equalTo(okBtn)
        }
        
        listView.snp.makeConstraints { make in
            if showsTitleView {
                make.top.equalTo(titleDivider.snp.bottom)
            } else {
                make.top.equalToSuperview()
            }
            make.left.right.equalToSuperview()
            make.bottom.equalTo(okBtn.snp.top).offset(-10)
        }
        
    }
    
    private lazy var bgView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius  = 3
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.transform = .init(scaleX: 1.5, y: 1.5)
        view.alpha = 0.1
        return view
    }()
    
    private var showsTitleView : Bool = true
    
    private lazy var titleLabel = {
        let lb = UILabel()
        lb.textColor = Constants.themeTitleColor
        lb.font = Constants.pingFangSCSemiboldFont(18)
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var titleDivider = {
        let divider = UIView()
        divider.backgroundColor = UIColor(white: 0, alpha: 0.1)
        return divider
    }()
    
    private lazy var listView = {
        let tbView = UITableView(frame: .zero, style: .plain)
        tbView.separatorStyle = .none
        tbView.dataSource = self
        tbView.delegate   = self
        tbView.bounces    = false
        tbView.register(SelectionCell.self, forCellReuseIdentifier: "SelectionCell")
        tbView.showsVerticalScrollIndicator = false
        tbView.backgroundColor = .clear
        return tbView
    }()
    
    private lazy var okBtn = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = Constants.themeColor
        btn.setTitle("Select", for: .normal)
        btn.titleLabel?.font = Constants.pingFangSCSemiboldFont(18)
        btn.titleLabel?.textColor = Constants.pureWhite
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(selectedBtnAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var doneBtn = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = Constants.themeDisabledColor
        btn.setTitle("Done", for: .normal)
        btn.titleLabel?.font = Constants.pingFangSCSemiboldFont(18)
        btn.titleLabel?.textColor = Constants.pureWhite
        btn.addTarget(self, action: #selector(cancelSelect), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    private var selectedAction : ((Selectionable) -> Void)?
    
    private var unselectedIndicatorText : String = ""
}

extension ListSelectionView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath) as! SelectionCell
        cell.model = content[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in 0 ..< content.count {
            if index == indexPath.row {
                content[index].isSelected = true
            } else {
                content[index].isSelected = false
            }
        }
        listView.reloadData()
    }
    
}

// MARK: - Private method
extension ListSelectionView {
    private func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.25) {
            self.bgView.transform = .identity
            self.bgView.alpha = 1
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.bgView.transform = .init(scaleX: 1.5, y: 1.5)
            self.alpha = 0.1
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc func cancelSelect() {
        dismiss()
    }
    
    @objc func selectedBtnAction() {
        var selectedModel : SelectionableModel?
        content.forEach { item in
            if item.isSelected {
                selectedModel = item
            }
        }
        
        if selectedModel == nil {
            HUD.flash(.label(unselectedIndicatorText), delay: 1.0)
        } else {
            selectedAction?(selectedModel!)
            dismiss()
        }
        
    }
}
