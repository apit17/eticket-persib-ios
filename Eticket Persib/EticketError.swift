//
//  EticketError.swift
//  Eticket Persib
//
//  Created by Apit on 7/10/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit
import SwiftyJSON

class EticketError: NSObject {

    private(set) var code:String!
    private(set) var desc:String!
    var errorData:JSON!
    
    init(error:NSError) {
        super.init()
        setSelf(code: "\(error.code)", desc: error.localizedDescription)
    }
    
    init(code:String, desc:String) {
        super.init()
        setSelf(code: code, desc: desc)
    }
    
    /**
     method for set variabel
     
     - parameter code: code of error
     - parameter desc: description of error
     */
    private func setSelf(code:String, desc:String){
        var description = desc
        if code == "500" || code == "3840"{
            description = "Maaf sementara permintaan anda tidak dapat diproses saat ini, silahkan coba beberapa saat lagi"
        }
        else if code == "-1009" || code == "-1001"{
            description = "Check Your Connection"
        }
        self.code = code
        self.desc = description
        
    }
    
}
