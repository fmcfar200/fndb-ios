//
//  ViewController.swift
//  fndb-ios
//
//  Created by fraser mcfarlane on 17/10/2018.
//  Copyright © 2018 P-Flow Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct itemShopResponse:Decodable {
        let date_layout:String?
        let lastupdate:Int?
        let date:String?
        let rows:Int?
        let vbucks:String?
        let items:[ShopItem]?
    
    }

    @IBOutlet weak var skinButton: UIView!
    @IBOutlet weak var statsButton: UIView!
    @IBOutlet weak var weaponsButton: UIView!
    @IBOutlet weak var leaderboardButton: UIView!
    @IBOutlet weak var challengesButton: UIView!
    @IBOutlet weak var newsButton: UIView!
    
    var searchType = SearchType.PROMO
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let key = String("a4587bc8429ba5f7e2be4d869fddf5ff")
        let url = URL(string: "https://fortnite-public-api.theapinetwork.com/prod09/store/get")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(key, forHTTPHeaderField: "Authorization")
        
        DispatchQueue.global(qos: .userInteractive).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                //let json = try? JSONSerialization.jsonObject(with: data, options: [])
                do {
                    let shopResponse = try JSONDecoder().decode(itemShopResponse.self, from: data)
                    //self.challengeCollection = challengeResponse.challenges
                    print(shopResponse.items?[0].name)
                    
                    DispatchQueue.main.async {
                        //self.tableView.reloadData()
                    }
                    
                    
                }catch let jsonErr{
                    print(jsonErr)
                }
                
                
            }
            task.resume()
        }

    }
    
    @IBAction func skinButtonTouch(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "segueHome")
        {
            let skinController = segue.destination as! SkinTableViewController
            theSearchType = self.searchType
            skinController.seasonNo = 0
        }
        
    }
    
    @IBAction func toSkinPress(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 2:
            searchType = SearchType.PROMO

        case 3:
            searchType = SearchType.SEASONAL

        default:
            searchType = SearchType.BP
        }
        performSegue(withIdentifier: "segueHome", sender: self)

        
    }
    
    
}

