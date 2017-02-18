//
//  Helper.swift
//  InstaPics
//
//  Created by Solomon Fesseha on 2/16/17.
//  Copyright © 2017 SoloInc. All rights reserved.
//


import UIKit
import AVFoundation

//Helper class to show alerts
class Helper {
    
    func successAlert(title: String, msg: String) {
        let banner = Banner(title: title, subtitle: msg, image: UIImage(named: "success"), backgroundColor: UIColor.green)
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    func errorAlert(title: String, msg: String) {
        let banner = Banner(title: title, subtitle: msg, image: UIImage(named: "error"), backgroundColor: UIColor.red)
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
}


extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}





