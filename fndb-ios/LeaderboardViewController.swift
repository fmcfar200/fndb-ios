//
//  LeaderboardViewController.swift
//  fndb-ios
//
//  Created by fraser mcfarlane on 24/10/2018.
//  Copyright © 2018 P-Flow Studios. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    struct LeaderboardResponse: Decodable {
        let window:String?
        let entries:[Leaderboard]
    }
    
    var leaderboardCollectionKills = [Leaderboard]()
    var leaderboardCollectionWins = [Leaderboard]()
    var leaderboardCollectionMins = [Leaderboard]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let key = String("a4587bc8429ba5f7e2be4d869fddf5ff")
        let url = URL(string: "https://fortnite-public-api.theapinetwork.com/prod09/leaderboards/get?window=top_10_kills")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(key, forHTTPHeaderField: "Authorization")
        request.setValue("v1.1", forHTTPHeaderField: "X-Fortnite-API-Version")
        request.setValue("application/form-data current", forHTTPHeaderField: "season")
        
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
                    let leaderboardResponse = try JSONDecoder().decode(LeaderboardResponse.self, from: data)
                    //self.challengeCollection = challengeResponse.challenges
                    print(leaderboardResponse)
                    
                    DispatchQueue.main.async {
                        //self.tableView.reloadData()
                    }
                    
                    
                }catch let jsonErr{
                    print(jsonErr)
                }
                
                
            }
            task.resume()
        }

        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
