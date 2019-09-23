//
//  Constants.swift
//  Memories
//
//  Created by tanuj tak on 5/10/19.
//  Copyright © 2019 tanujtak. All rights reserved.
//

import Foundation
import UIKit
import Localize

let APP_NAME = "MEMORIES"
let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

public struct AppStrings {
    struct Title {
        static let done = "Done".localized
        static let ok = "Ok".localized
        static let dismiss = "Dismiss".localized
        static let cancel = "Cancel".localized
        static let alert = "Alert".localized
    }
    
    struct Messages {
        static let enterDetails = "Please enter ".localized
        static let selectDetails = "Please select ".localized
    }
    
    struct Keys {
        static let sequence = "sequence"
    }
}

extension Notification.Name {
    static let notificationTriggered = Notification.Name("NotificationTriggered")
}
