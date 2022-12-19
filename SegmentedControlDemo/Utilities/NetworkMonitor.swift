//
//  NetworkMonitor.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import Foundation
import Network

class NetworkMonitor {
   static let shared = NetworkMonitor()

   let monitor = NWPathMonitor()
   var isReachable: Bool { status == .satisfied }
   private var status: NWPath.Status = .requiresConnection

   func startMonitoring() {
      monitor.pathUpdateHandler = { [weak self] path in
         self?.status = path.status
         print("we are connected: \(path.status == .satisfied)")
         DispatchQueue.main.async {
            NotificationCenter.default.post(InAppNotification.connectivityDidChange.notification)
         }
      }
   }

   func stopMonitoring() {
      monitor.cancel()
   }
}
