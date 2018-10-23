//
//  WeaponsViewController.swift
//  fndb-ios
//
//  Created by fraser mcfarlane on 23/10/2018.
//  Copyright © 2018 P-Flow Studios. All rights reserved.
//

import UIKit

struct WeaponsResponse:Decodable{
    let rarity:String?
    let css:String?
    let rows:Int?
    let weapons:[Weapon]?
}

class WeaponsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    var weaponCollection = [Weapon]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Do any additional setup after loading the view.
        
        let key = String("a4587bc8429ba5f7e2be4d869fddf5ff")
        let url = URL(string: "https://fortnite-public-api.theapinetwork.com/prod09/weapons/get")!
        var request = URLRequest(url: url)
        request.setValue(key, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
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
                //print("responseString = \(String(describing: responseString))")
                do {
                    let weaponResponse = try JSONDecoder().decode(WeaponsResponse.self, from: data)
                    self.weaponCollection = weaponResponse.weapons!
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                       
                    }
                    
                    
                }catch let jsonErr{
                    print(jsonErr)
                }
            }
            task.resume()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weaponCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = "WeaponCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? WeaponCollectionViewCell else{
            fatalError("cell error: not member of [CELL]")
        }
        
        downloadImage(urlstr: (self.weaponCollection[indexPath.row].images?.background)!, imageView: cell.cellImage)
        
        cell.layoutSubviews()
        return cell
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