//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Giovanna Pezzini on 12/01/21.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
