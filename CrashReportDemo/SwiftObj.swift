//
//  SwiftObj.swift
//  CrashReportDemo
//
//  Created by mengshun on 2022/6/13.
//

import UIKit

class SwiftObj: NSObject {
    
    @objc static func action() {
        let a = [1]
        a[2]
    }

}
