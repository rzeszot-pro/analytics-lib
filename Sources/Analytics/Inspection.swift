//
//  Inspection.swift
//  
//
//  Created by Damian Rzeszot on 26/10/2019.
//

import Foundation

func inspect(_ text: String) {
    #if DEBUG
    print(text)
    #endif
}
