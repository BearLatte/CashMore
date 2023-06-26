//
//  SelectionCell.swift
//  CashMore
//
//  Created by Tim on 2023/6/10.
//

class SelectionCell : UITableViewCell {
    var model : Selectionable? {
        didSet {
            displayLabel.text = model?.displayText
            selectionIcon.isHidden = !(model?.isSelected ?? false)
            layoutIfNeeded()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle  = .none
        contentView.addSubview(displayLabel)
        contentView.addSubview(selectionIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionIcon.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.right.equalTo(-10)
            make.size.equalTo(CGSize(width: 14, height: 14))
            make.bottom.equalTo(-15).priority(.high)
        }
        
        displayLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(10)
            make.right.lessThanOrEqualTo(selectionIcon.snp.left).offset(-10)
        }
    }
    
    private lazy var displayLabel = {
        let lb = UILabel()
        lb.textColor = Constants.themeTitleColor
        lb.font = Constants.pingFangSCRegularFont(14)
        return lb
    }()
    
    private lazy var selectionIcon = {
        let iconView = UIImageView(image: R.image.check_box_full())
        iconView.isHidden = true
        iconView.contentMode = .scaleAspectFit
        return iconView
    }()
}
