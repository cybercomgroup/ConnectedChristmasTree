//
//  NetWorkHandler.swift
//  ChristmasLight
//
//  Created by Shan Jiang on 2016-11-24.
//  Copyright © 2016 Shan Jiang. All rights reserved.
//

import Foundation
import Alamofire


class NetWorHandler{
    
    
    
    func readIPfromFile() -> String{
        
        var ipString = [String]()
        
        if let path = Bundle.main.path(forResource: "ip", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let ipString = data.components(separatedBy: .newlines)
                print("ip read from file: \(ipString)")
                return ipString[0]
            } catch {
                print(error)
            }
        }
        
        return ipString[0]
        
    }
    
    func sendData(parameters: Parameters,  ipAddress: String) {

        var ip = ipAddress + "/changecolor"
        
        Alamofire.request(ip, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
           
            print("ipAddress: \(ip) ")
            print("response.response:  \(response.response)") // HTTP URL response
            
            print("parameters: \(parameters)")
            print("response.request:  \(response.request)")  // original URL request
            print("----------------------------")
            

        }
    }
}
