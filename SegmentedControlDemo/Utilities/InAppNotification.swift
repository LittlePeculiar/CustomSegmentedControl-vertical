//
//  InAppNotification.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import Foundation

// defines all notifications which can be triggered via NotificationCenter
enum InAppNotification: String {
   case connectivityDidChange

   var notification: Notification {
      let name = Notification.Name.init(rawValue: rawValue)
      return Notification(name: name)
   }

   var notificationName: String {
      return rawValue
   }
}
