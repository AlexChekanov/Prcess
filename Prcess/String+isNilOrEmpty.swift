//
//  String+isNilOrEmpty.swift
//  Gestalt
//
//  Created by Alexey Chekanov on 6/20/17.
//  Copyright © 2017 Alexey Chekanov. All rights reserved.
//


protocol OptionalString {}
extension String: OptionalString {}

extension Optional where Wrapped: OptionalString {
    var isNilOrEmpty: Bool {
        return ((self as? String) ?? "").isEmpty
    }
}
