//
//  OtherCell.swift
//  MQTTSample
//
//  Created by Hansub Yoo on 2020/04/21.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

import UIKit

class OtherCell: UITableViewCell {
    var messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setViewFoundations()
        self.setAddSubViews()
        self.setLayouts()
        self.setDelegates()
        self.setAddTargets()
        self.setGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewFoundations() {
        
    }
    
    func setAddSubViews() {
        self.contentView.addSubview(self.messageLabel)
    }
    
    func setLayouts() {
        let safeArea = self.contentView.safeAreaLayoutGuide
        
        self.messageLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(safeArea.snp.leading).offset(16)
            make.top.equalTo(safeArea.snp.top).offset(8)
            make.bottom.equalTo(safeArea.snp.bottom).offset(-8)
        }
        self.messageLabel.sizeToFit()
    }
    
    func setDelegates() {
        
    }
    
    func setAddTargets() {
        
    }
    
    func setGestures() {
        
    }
}
