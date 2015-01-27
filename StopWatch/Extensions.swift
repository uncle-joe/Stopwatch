//
//  Extensions.swift
//  StopWatch
//
//  Created by Sergey Kaminski on 1/24/15.
//  Copyright (c) 2015 Sergey Kaminski. All rights reserved.
//

import Foundation

extension Int {
    func format(f: String) -> String {
        return NSString(format: "%\(f)d", self)
    }
}