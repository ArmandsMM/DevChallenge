//
//  ViewController.swift
//  DevChallenge
//
//  Created by Mikanovskis, Armands on 6/26/17.
//  Copyright © 2017 Mikanovskis, Armands. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainVC: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    
    fileprivate let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confifureNavigationBarAppearance()
        
        collectionView.delegate = self
        
        let allRibots$ : Observable<[Ribot]> = RibotAPI.getRibots()
        
        
        allRibots$.bindTo(collectionView.rx.items(cellIdentifier: "cell")) { _, ribot, cell in
            if let currentCell = cell as? RibotCollectionViewCell {
                currentCell.updateCellWith(ribot: ribot)
            }
        }.addDisposableTo(disposeBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRibotDetails" {
            if let destVC = segue.destination as? RibotDetailVC {
                if let cell = sender as? RibotCollectionViewCell {
                    destVC.ribotData = cell.ribotCellData
                    if let image = cell.imageView.image {
                        destVC.image = image
                    } else {
                        destVC.image = UIImage(named: "noImage")!
                    }
                    
                }
            }
        }
    }
    
    func confifureNavigationBarAppearance(){

        UINavigationBar.appearance().barTintColor = .green
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
    }

}

extension MainVC {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = view.frame.width * 0.05 * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: -30, left: view.frame.width * 0.05, bottom: 0, right: view.frame.width * 0.05)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.frame.width * CGFloat(0.05)
    }
}
