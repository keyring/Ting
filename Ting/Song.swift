//
//  Song.swift
//  Ting
//
//  Created by keyring on 11/3/15.
//  Copyright © 2015 cude. All rights reserved.
//

import Foundation

class Song:NSObject {
    var picture:NSString = ""
    var albumtitle: NSString = ""
    var ssid : NSString = ""
    var title: NSString = ""
    var url: NSString = ""
    var artist: NSString = ""
    var length: NSNumber = 0
    var file_ext: NSString = ""
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}