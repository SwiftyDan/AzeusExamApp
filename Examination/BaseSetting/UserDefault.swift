//
//  UserDefault.swift
//  LetsBee
//
//  Created by WonJun Choi on 2020/04/14.
//  Copyright © 2020 WonJun Choi. All rights reserved.
//

import Foundation
import SwiftyJSON


var languagex: String? {
    get {
        return UserDefaults.standard.string(forKey: ukLanguage)
    }
    set(v) {
        let ud = UserDefaults.standard
        ud.set(v, forKey: ukLanguage)
        ud.synchronize()
    }
}

var languageSettingx: Bool {
    get {
        return UserDefaults.standard.bool(forKey: ukLanguageSetting)
    }
    set(v) {
        let ud = UserDefaults.standard
        ud.set(v, forKey: ukLanguageSetting)
        ud.synchronize()
    }
}






var recentSearchWordx: [String]? {
    get {
        return UserDefaults.standard.stringArray(forKey: ukRecentSearchWord)
    }
    set(v) {
        let ud = UserDefaults.standard
        ud.set(v, forKey: ukRecentSearchWord)
        ud.synchronize()
    }

}


var savedRecentData: [SavedData]? {
    get {
        if let loadedData = UserDefaults().data(forKey: ukSelectedMenuMart) {
            
            return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedData) as? [SavedData]

        }
        return nil
    }
    set(v) {
        
        if let value = v {
            guard let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false) else {
                fatalError("Archive savedData failed")
            }

            let ud = UserDefaults.standard
            ud.set(archiveData, forKey: ukSelectedMenuMart)
            ud.synchronize()
        }

    }
}


func getLanguage() -> String {
    guard let language = languagex else {return "EN"}
    return language
}
