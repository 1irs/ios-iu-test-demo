//
//  Suggestion.swift
//  bizi-baza
//
//  Created by Vladimir Obrizan on 29.05.2020.
//  Copyright © 2020 Design and Test Lab. All rights reserved.
//

import Foundation


@objc protocol Suggestion {
    var title: String { get }
    var subtitle: String { get }
    var id: String { get }
}
