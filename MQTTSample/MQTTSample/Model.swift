//
//  Model.swift
//  MQTTSample
//
//  Created by Hansub Yoo on 2020/04/21.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

import Foundation

struct Message {
    var id: UInt32
    
    var message: String
    
    var isSender: Bool
    
    var date: Date
}
