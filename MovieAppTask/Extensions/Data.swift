//
//  Data.swift
//  MovieAppTask
//
//  Created by Vitalii Tar on 12/14/20.
//  Copyright © 2020 Vitalii Tar. All rights reserved.
//

// Only for debug purpose

import Foundation

extension Data {
    func printJSON() {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
    }
}
