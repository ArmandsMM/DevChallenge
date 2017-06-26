//
//  RibonAPI.swift
//  DevChallenge
//
//  Created by Mikanovskis, Armands on 6/26/17.
//  Copyright © 2017 Mikanovskis, Armands. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct RibotAPI {
    
    static func getImageFromURL(urlString: String) -> Observable<UIImage> {
        guard let url = URL(string: urlString) else { return Observable.just(UIImage(named: "noImage")!) }
            let request = URLRequest(url: url)
            return URLSession.shared.rx.response(request: request).map{ response, data in
                return UIImage(data: data)!
            }.distinctUntilChanged().shareReplay(1)
        
    
    }
    
    static func getRibots() -> Observable<[Ribot]> {
        let url = URL(string: "https://api.ribot.io/ribots")!
        return URLSession.shared.rx.json(url: url)
            .map { json in
                guard let json = json as? [[String: AnyObject]] else {
                    return []
                }
                
                return self.parseJSON(json)
        }
    }
    
    static private func parseJSON(_ json: [[String: AnyObject]]) -> [Ribot] {
        
        let parseResults: [Ribot] = json.map { item in
            let profile = item["profile"]
            
            let id = profile?["id"] as? String
            let email = profile?["email"] as? String
            let avatar = profile?["avatar"] as? String
            let dateOfBirth = profile?["dateOfBirth"] as? String
            let hexColor = profile?["hexColor"] as? String
            let bio = profile?["bio"] as? String
            let isActive = profile?["isActive"] as? Bool
            let name = profile?["name"] as? [String: String]
            
            
            let ribot = Ribot(id: id ?? "",
                              email: email ?? "",
                              avatar: avatar ?? "",
                              dateOfBirth: dateOfBirth ?? "",
                              hexColor: hexColor ?? "",
                              bio: bio ?? "",
                              isActive: isActive ?? false,
                              name: RibotName(first: name?["first"] ?? "", last: name?["last"] ?? ""))
            return ribot
            
        }
        
        return parseResults
    }
}
