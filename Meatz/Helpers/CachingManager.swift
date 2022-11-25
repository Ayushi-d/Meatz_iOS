//
//  CachingManager.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import Foundation

final class CachingManager {
    static let shared = CachingManager()
    let userDefaults: UserDefaults

    private init() {
        userDefaults = UserDefaults.standard
    }
    
    func setLogin(_ status: Bool) {
        userDefaults.setValue(status, forKey: Key.login.rawValue)
    }
    
    var isLogin: Bool {
        return userDefaults.bool(forKey: Key.login.rawValue)
    }
    
    var isFirstTime: Bool {
        return !userDefaults.bool(forKey: Key.firstTime.rawValue) /// returned value
    }
    
    var isFirstTimeOpenSetting: Bool {
        return !userDefaults.bool(forKey: Key.fisrtTimeOpenSetting.rawValue) /// returned value
    }
    
 
    func settingIsOpened() {
        userDefaults.setValue(true, forKey: Key.fisrtTimeOpenSetting.rawValue) /// closing the flag after asked
    }
    
    /// called to remove first time flag
    func configLangSelected() {
        userDefaults.setValue(true, forKey: Key.firstTime.rawValue) /// closing the flag after asked
    }
    
    func removeCurrentUser(){
        setLogin(false)
        userDefaults.removeObject(forKey: Key.user.rawValue)
    }
    func cache(_ user: User) -> Bool{
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(user)
            userDefaults.setValue(data, forKey: Key.user.rawValue)
            setLogin(true)
            return true
        } catch {
            print(error.localizedDescription)
            return false 
        }
    }
    
    func getUser() -> User? {
        let decoder = PropertyListDecoder()
        if let data = userDefaults.data(forKey: Key.user.rawValue) {
            do {
                return try decoder.decode(User.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /// this is called to remove all objects (only for test )
    func reset() {
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
    }
    
    func loginSocialWithEmptyPhone()->Bool{
        //self.getUser()?.mobile.isEmpty
        return (self.getUser()?.mobile.isEmpty ?? false)
    }
    
    enum Key: String {
        case login
        case firstTime
        case user
        case fisrtTimeOpenSetting
    }
}

//MARK:-  Keychain

extension CachingManager{
    var key: String {
        return "isLogin"
    }
    
    private var keychain: KeychainSwift {
        return KeychainSwift()
    }

    func cacheInKeychain(_ user: User) {
        keychain.setElement(user, forKey: key)
    }
    
    func deleteForKey() {
        keychain.delete(key)
    }
}
