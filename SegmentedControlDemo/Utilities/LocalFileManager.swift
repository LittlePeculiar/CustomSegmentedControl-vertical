//
//  LocalFileManager.swift
//
//  Created by Gina Mullins on 11/10/22.
//

import UIKit

class LocalFileManager {

    static let shared = LocalFileManager()
    private init() {}
    func save(data: Data, urlPath: String) {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(urlPath) else {
           print("error making path")
           return
        }
        if !FileManager.default.fileExists(atPath: path.path){
            FileManager.default.createFile(atPath: (path.path), contents: data, attributes: nil)
        } else {
            do {
                try data.write(to: path)
            } catch let error {
                print("error saving error: \(error)")
            }
        }
    }
    
    func getData(urlPath: String) -> Data? {
       guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(urlPath) else {
          print("error making path")
          return nil
       }
        if FileManager.default.fileExists(atPath: path.path){
            do {
                let data = try Data(contentsOf: path)
                return data
            } catch let error {
                print("error saving error: \(error)")
            }
        }
        return nil
    }
}
