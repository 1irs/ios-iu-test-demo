//
//  FakeSearchService.swift
//  UIDemo
//
//  Created by Vladimir Obrizan on 31.05.2020.
//  Copyright © 2020 Design and Test Lab. All rights reserved.
//

import Foundation


public class FakeSuggestService: SuggestService {

    var words: [String]
    
    init(words: [String]) {
        self.words = words
    }
    
    func suggest(query: String, completion: @escaping ([String], Error?) -> Void) {
        let trimmedString = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.count > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                completion(self!.words.filter { $0.starts(with: query) }, nil)
            }
        } else {
            completion([], nil)
        }
    }
}
