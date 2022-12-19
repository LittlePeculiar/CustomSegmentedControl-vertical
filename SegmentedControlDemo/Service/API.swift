//
//  API.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import Foundation

enum APIError: Error {
    case noInternet
    case invalidUrl
    case responseFailure
    case noData
    case serializationError
}

class API {
   static var shared = API()

   private let session: URLSession
   private let networkTimeout = 60.0
   private var isReachable: Bool {
      return NetworkMonitor.shared.isReachable
   }

   func fetch<T: Decodable>(payload: T.Type, endpoint: APIEndpoint, completion: @escaping (Result<T?, APIError>) -> Void) {
      guard let urlRequest = getUrlRequest(endpoint: endpoint) else {
         completion(.failure(.invalidUrl))
         return
      }

       let task = session.dataTask(with: urlRequest) { (data, response, error) in
           guard let data = data else {
               completion(.failure(.noData))
               return
           }
           do {
               let results = try JSONDecoder().decode(T.self, from: data)
               completion(.success(results))
           } catch (let error) {
               print(error)
               completion(.failure(.serializationError))
               return
           }
       }
      task.resume()
   }

   private func getUrlRequest(endpoint: APIEndpoint) -> URLRequest? {
      var headers: [String:String] = [:]
      headers["Content-Type"] = "application/json"

      guard let url = URL(string: endpoint.path) else { return nil }
      var urlRequest = URLRequest(url: url)
      urlRequest.httpMethod = "GET"
      urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
      headers.forEach({
         urlRequest.setValue($1, forHTTPHeaderField: $0)
      })
      return urlRequest
   }

   init() {
      let sessionConfig = URLSessionConfiguration.default
      sessionConfig.timeoutIntervalForRequest = networkTimeout
      sessionConfig.timeoutIntervalForResource = networkTimeout
      self.session = URLSession(configuration: sessionConfig)

      NotificationCenter.default.addObserver(self, selector: #selector(connectivityChanged(notification:)), name: InAppNotification.connectivityDidChange.notification.name, object: nil)
   }

   @objc func connectivityChanged(notification: NSNotification) {
      print("*** connectivity changed: \(NetworkMonitor.shared.isReachable)")
   }

}

