//
//  HttpProtocol.swift
//  Ting
//
//  Created by keyring on 11/3/15.
//  Copyright © 2015 cude. All rights reserved.
//

import Foundation

protocol HttpProtocol{
    func didReceiveResults(result: NSDictionary)
}

class HttpController:NSObject {
    var delegate:HttpProtocol?
    
    func onSearch(url:String){
        var nsurl = NSURL(string: url)!
        var request = NSURLRequest(URL: nsurl)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse?, data:NSData?, error:NSError?)->Void in
            if(data != nil){

                let jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                self.delegate?.didReceiveResults(jsonResult)
            }
        })
    }
}