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

class MainVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just(
            (0..<20).map{ "Test \($0)" }
        )
        
        items.asObservable().bindTo(self.collectionView.rx.items(cellIdentifier: "cell", cellType: CustomCollectionViewCell.self)) { row, data, cell in
            cell.data = data
            }.addDisposableTo(disposeBag)
        
    }

}

