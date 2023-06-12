//
//  URLEncoder.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

struct URLEncoder {
    let encode: (String) -> String?
}

extension URLEncoder {
    static let `default`: URLEncoder = {
        URLEncoder { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) }
    }()
}
