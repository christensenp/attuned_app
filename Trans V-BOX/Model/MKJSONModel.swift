//
//  MKJSONModel.swift
//  Sagexool
//
//  Created by Sagexool on 24/09/18.
//  Copyright © 2018 Sagexool. All rights reserved.
//

import Foundation
protocol MKJSONModel: Codable {
    init?(object: [String:Any])
    
}

extension MKJSONModel{
    init?(object: [String:Any]){
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let jsonData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
            let selfValue = try? decoder.decode(Self.self, from: jsonData as Data){
            self = selfValue
        }else{
            return nil
        }
    }
    
    
    func toData()->Data?{
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            return jsonData
        }
        catch{
            
        }
        return nil
    }
    func toDataWithSnakeCase()->Data?{
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let jsonData = try jsonEncoder.encode(self)
            return jsonData
        }
        catch{
            
        }
        return nil
    }
    
    
    func toJSONObj()->Any?
    {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase

        guard let jsonData = try? jsonEncoder.encode(self) else {
            return nil
        }
        
        let jsonObj = try? JSONSerialization.jsonObject(with: jsonData, options: [] )
        return jsonObj
    }
    
    
    
    

}
