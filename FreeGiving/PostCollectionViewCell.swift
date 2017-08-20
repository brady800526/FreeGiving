//
//  PostCollectionViewCell.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/9.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import SDWebImage

class PostCollectionViewCell: UICollectionViewCell {

    var productPost: ProductPost? {

        didSet {

            setupCell()

        }

    }

    func setupCell() {
        self.productImageView.sd_setImage(with: URL(string: (productPost?.productImageURL!)!), placeholderImage: nil)
        self.productLable.text = productPost?.title
        self.timeLable.text = productPost?.productOnShelfTime
//        self.layer.borderWidth = 5
//        self.layer.borderColor = UIColor.yellow.cgColor
    }

    var productImageView: UIImageView = {
        let pv = UIImageView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = UIColor.red
        return pv
    }()

    var timeLable: UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.backgroundColor = UIColor.seaBlue
        return tl
    }()

    var productLable: UILabel = {
        let pl = UILabel()
        pl.translatesAutoresizingMaskIntoConstraints = false
        pl.backgroundColor = UIColor.seaBlue
        return pl
    }()
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(productImageView)
        addSubview(timeLable)
        addSubview(productLable)

        productImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        productImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        productImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        productImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true

        timeLable.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        timeLable.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        timeLable.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLable.heightAnchor.constraint(equalToConstant: 30).isActive = true

        productLable.heightAnchor.constraint(equalToConstant: 30).isActive = true
        productLable.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        productLable.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        productLable.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
