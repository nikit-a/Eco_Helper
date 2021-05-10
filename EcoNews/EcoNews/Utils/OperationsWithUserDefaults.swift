//
//  OperationsWithUserDefaults.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 09.05.2021.
//

import Foundation

class OperationsUserDef{
    static let defaults = UserDefaults.standard
    static func setInDefaults(firstName: String, secName: String, email: String, uidUser: String){
        defaults.set(firstName, forKey: "firstNameUser")
        defaults.set(secName, forKey: "secondNameUser")
        defaults.set(email, forKey: "emailUser")
        defaults.set(uidUser    , forKey: "userUID")
    }
}
