//
//  Background.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 9/29/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBackground() {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "University_Campus.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleToFill
        
        //self.addSubview(imageViewBackground)
        // self.sendSubviewToBack(imageViewBackground)
    }
}
