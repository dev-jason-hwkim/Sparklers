//
//  Color.swift
//  Sparklers
//
//  Created by HyunWoo-Kim on 2018. 9. 2..
//  Copyright © 2018년 HyunWoo. All rights reserved.
//

import Foundation
import UIKit
struct Color {
    var color = UIColor.white
    var name = ""
    var resource: UIImage? = #imageLiteral(resourceName: "preview_sample")
    
    init(color:UIColor, name:String, resource:UIImage? = nil) {
        self.color = color
        self.name = name
        self.resource = resource        
    }
    
}
