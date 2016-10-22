//
//  GolesAPI.swift
//  OpenGoles
//
//  Created by Alberto on 22/10/16.
//  Copyright © 2016 Alberto. All rights reserved.
//

import Foundation

// For callbacks
typealias ServiceResponse = (NSError?, [String:AnyObject]?) -> Void
typealias ServiceBoolResponse = (NSError?, Bool) -> Void

enum MatchState:Int{
    case notStarted = 0, inGame = 1, finished = 3
}

class GolesAPI {
    static let sharedInstance = GolesAPI()
    
    let BASE_URL = "http://api.golesmessenger.net/rackservices/rest/v4/"
    
    // let MATCH_STATE = ["FINISHED":3, "IN_GAME":1, "NOT_STARTED":0]
    
    func get(_ url:String, onCompletion:@escaping ServiceResponse)
    {
        let finalUrl = "\(BASE_URL)\(url)"
        var request = URLRequest(url: URL(string: finalUrl)!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        do {
            request.addValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
            request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                do{
                    //print("Response: \(response)")
                    let res = response as! HTTPURLResponse
                    //print(res)
                    
                    let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    //print("Body: \(strData)")
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? [String:AnyObject]
                    
                    if res.statusCode == 200{
                        onCompletion(nil, json)
                    }else{
                        onCompletion(NSError(domain: "get", code: 999, userInfo: nil), nil)
                    }
                }catch{
                    print("Error:\n \(error)")
                    onCompletion(NSError(domain: "get", code: 998, userInfo: nil), nil)
                }
                
            })
            
            task.resume()
        }catch{
            print("Error:\n \(error)")
            return
        }
    }
    
    func post(_ data:String, url:String, onCompletion:@escaping ServiceResponse)
    {
        let params = data
        let finalUrl = "\(BASE_URL)\(url)"
        
        var request = URLRequest(url: URL(string: finalUrl)!)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        do {
            request.httpBody = params.data(using: String.Encoding.utf8)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                do{
                    //print("Response: \(response)")
                    let res = response as! HTTPURLResponse
                    //print(res)
                    
                    let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    //print("Body: \(strData)")
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? [String:AnyObject]
                    
                    if res.statusCode == 200{
                        onCompletion(nil, json)
                    }else{
                        onCompletion(NSError(domain: "post", code: 999, userInfo: nil), nil)
                    }
                }catch{
                    print("Error:\n \(error)")
                    onCompletion(NSError(domain: "post", code: 998, userInfo: nil), nil)
                }
                
            })
            
            task.resume()
        }catch{
            print("Error:\n \(error)")
            return
        }
    }
    
    
    
    func getLeagues(onCompletion:@escaping ServiceResponse)
    {
        let url = "team/getLeagues"
        post("", url: url, onCompletion: onCompletion)
    }
    
    func getNextFixtures(_ idLeague:Int, onCompletion:@escaping ServiceResponse)
    {
        let url = "fixture/nextFixtures"
        let data = "{\"appId\":2,\"idLeague\":\(idLeague)}"
        post(data, url: url, onCompletion: onCompletion)
    }
    
    func getTournaments(_ idLeague:Int, onCompletion:@escaping ServiceResponse)
    {
        let url = "fixture/tournaments"
        let data = "\(idLeague)"
        post(data, url: url, onCompletion: onCompletion)
    }
    
    func getClassification(_ idTournament:Int, onCompletion:@escaping ServiceResponse)
    {
        let url = "fixture/classification"
        let data = "\(idTournament)"
        post(data, url: url, onCompletion: onCompletion)
    }
    
    
}
