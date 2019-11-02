//
//  tutaUser.swift
//  Tuta
//
//  Created by 陈明煜 on 11/2/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation
import Firebase

class tutaUser{
    var name : String?
    var email : String?
    var url : String?
    var gender : String?
    var rate : String?
    var description: String?
    
    init(name:String?, email:String?, url:String?, gender:String?, rate:String?, description:String?){
        self.name = name
        self.email = email
        self.url = url
        self.gender = gender
        self.rate = rate
        self.description = description
        
    }
    
    
    
}

