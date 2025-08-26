//
//  ClassName.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//

import Foundation

protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}
extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}
extension NSObject: ClassNameProtocol {}
