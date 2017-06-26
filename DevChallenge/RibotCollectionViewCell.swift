//
//  RibotCollectionViewCell.swift
//  DevChallenge
//
//  Created by Armands Mikanovskis on 26/06/2017.
//  Copyright © 2017 Mikanovskis, Armands. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RibotCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    var ribotCellData : Ribot = Ribot(id: "",
                                      email: "",
                                      avatar: "",
                                      dateOfBirth: "",
                                      hexColor: "",
                                      bio: "",
                                      isActive: true,
                                      name: RibotName(first: "", last: ""))

    
    public func updateCellWith(ribot: Ribot) {
        ribotCellData = ribot

        nameLabel.text = "\(ribot.name.first) \(ribot.name.last)"

       
        RibotAPI.getImageFromURL(urlString: ribot.avatar)
            .distinctUntilChanged()
            .bindTo(imageView.rx.image)
            .addDisposableTo(disposeBag)
        
        backgroundColor = UIColor(hex: ribot.hexColor)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hexColor = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexColor)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
