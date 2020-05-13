//
//  Wiki.swift
//  FlowerType
//
//  Created by Tran Le on 5/12/20.
//  Copyright © 2020 TL Inc. All rights reserved.
//

import Foundation

//protocol to update when flower description is loaded
protocol WikiManagerDelegate {
    func didUpdateWiki(_ wiki: WikiManager, description: String)
    func didFailWithError(error: Error)
}

struct WikiManager {
    
    let varURL = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&indexpageids&redirects=1"
    
    var delegate: WikiManagerDelegate?
    
    func fetchFlower(flowerName: String) {
        let originalString = "\(varURL)&titles=\(flowerName)"
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let urlString = urlString {
            performRequest(urlString: urlString)
        }
    }
    
    func performRequest(urlString: String){
        
        //1. Create a URL
        if let url = URL(string: urlString) {
            
            //2. Create
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let description = self.parseJSON(flowerData: safeData) {
                        self.delegate?.didUpdateWiki(self, description: description)
                    }
                }
            }
            
            //4. start the task
            task.resume()
        }
        
    }
    
    func parseJSON(flowerData: Data) -> String? {
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(FlowerData.self, from: flowerData)
            print("1. data decoded: \(decodedData)")
            
            let pageID = decodedData.query.pageids[0]
            
            let description = decodedData.query.pages[pageID]?.extract
            
            return description
        }
            
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

