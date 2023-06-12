//
//  Response.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

final class Response<Meta: Codable, Data: Codable>: Codable {
    let data: Data
    let meta: Meta

    init(data: Data, meta: Meta) {
        self.data = data
        self.meta = meta
    }
}
