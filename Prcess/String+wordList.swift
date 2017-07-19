//
//  String+wordList.swift
//  Gestalt
//
//  Created by Alexey Chekanov on 6/20/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//


extension String {
    var wordList: [String] {
        return Array(Set(components(separatedBy: .punctuationCharacters).joined(separator: "").components(separatedBy: " "))).filter {$0.characters.count > 0
        }
    }
}
