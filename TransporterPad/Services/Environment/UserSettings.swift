//
//  UserSettings.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/09/15.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa

class UserSettings: NSObject {

    let userDefaults: UserDefaults = UserDefaults.standard

    var iosDeployToolPath: String? {
        get {
            return userDefaults.string(forKey: "iosDeployToolPath")
        }
        set(value) {
            userDefaults.set(value, forKey: "iosDeployToolPath")
        }
    }

    var adbToolPath: String? {
        get {
            return userDefaults.string(forKey: "adbToolPath")
        }
        set(value) {
            userDefaults.set(value, forKey: "adbToolPath")
        }
    }
}