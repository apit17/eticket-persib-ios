//
//  WebService.swift
//  Eticket Persib
//
//  Created by Apit on 7/10/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PKHUD

class WebService: NSObject {
    
    static var manager:SessionManager!
    static var managerUpload:SessionManager!
    static var currentController:UIViewController!
    static var req:Request!
    
    static var baseUrl = "http://192.168.1.6:8000/"
    static var urlAPI = baseUrl + "api/v1/"
    static var urlImage = baseUrl + "images/"
    static var login = urlAPI + "customer/login"
    static var booking = urlAPI + "schedule-book"
    static var uploadImage = urlAPI + "insert/transaction"
    static var getTicket = urlAPI + "schedule-detail"
    static var getHistory = urlAPI + "transaction"
    class func GET(url:String, param:[String: Any], headers:[String:String],hud:Bool, hudString:String, success: @escaping (JSON) -> Void, failure: @escaping (EticketError) -> Void){
        if manager == nil{
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            manager = SessionManager(configuration: configuration)
        }
        
        let req = manager.request(url, method: HTTPMethod.get, parameters: param, encoding: URLEncoding.default, headers: headers)
        if hud{
            HUD.flash(.label(hudString), delay: 2.0) { _ in}
        }
        req.responseJSON { (response) -> Void in
            switch response.result {
            case .success(let json):
                print("Success with JSON: \(json)")
                let jObject = JSON(json)
                success(jObject)
            case .failure(let error):
                if hud{
                    HUD.flash(.error)
                }
                failure(EticketError(error: error as NSError))
            }
        }
    }

    class func POST(url : String,queryString : [String : Any],headers:[String:String] , success:@escaping (JSON) ->Void,failure : @escaping (EticketError)->Void )
    {
        if manager == nil {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            manager = SessionManager(configuration: configuration)
        }
        
        let req = manager.request(url, method: HTTPMethod.post, parameters: queryString, encoding: URLEncoding.default, headers: headers)
        
        req.responseJSON { (response) in
            switch response.result {
            case .success(let json):
                print("Success with JSON: \(json)")
                let jObject = JSON(json)
                success(jObject)
            case .failure(let error):
//                if hud{
//                    HUD.flash(.error)
//                }
                failure(EticketError(error: error as NSError))
            }
        }
    }
}
