//
//  RibotDetailVC.swift
//  DevChallenge
//
//  Created by Armands Mikanovskis on 26/06/2017.
//  Copyright © 2017 Mikanovskis, Armands. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RibotDetailVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!

    @IBOutlet weak var emailButton: UIButton!
    var image : UIImage = UIImage()
    
    let disposeBag = DisposeBag()
    
    var ribotData : Ribot = Ribot(id: "",
                                      email: "",
                                      avatar: "",
                                      dateOfBirth: "",
                                      hexColor: "",
                                      bio: "",
                                      isActive: true,
                                      name: RibotName(first: "", last: ""))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ribotData$ : Observable<Ribot> = Observable<Ribot>.just(ribotData).observeOn(MainScheduler.instance).shareReplayLatestWhileConnected()
        ribotData$.subscribe(onNext: { [weak self] ribot in
            self?.updateUIWith(ribot: ribot)
        }).addDisposableTo(disposeBag)
        
        let image$ : Observable<UIImage> = Observable<UIImage>.just(image)
        image$.bindTo(profileImageView.rx.image).addDisposableTo(disposeBag)
        
        emailButton.rx.tap.asObservable()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.handleEmailButtonTap()
            }).addDisposableTo(disposeBag)
    }
    
    func updateUIWith(ribot: Ribot) {
        self.nameLabel.text = "\(ribot.name.first) \(ribot.name.last)"
        self.emailLabel.text = ribot.email
        self.activityLabel.text = ribot.isActive ? "active" : "not active"
        self.activityLabel.textColor = ribot.isActive ? .green : .orange
        self.bioLabel.text = ribot.bio.characters.count > 0 ? ribot.bio : "no bio added"
        self.bioLabel.textAlignment = ribot.bio.characters.count > 0 ? .left : .center
        self.view.backgroundColor = UIColor(hex: ribot.hexColor)
    }
    
    func handleEmailButtonTap() {
        if self.ribotData.email.characters.count == 0 { return }
        let email = self.ribotData.email
        if let url = URL(string: "mailto:\(email)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            
        }
    }
}
