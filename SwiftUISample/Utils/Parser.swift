//
//  Parser.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 10/03/2024.
//

import Foundation

class JSONParser
{
    private let decoder = JSONDecoder()
    
    func decodeType<T>(_ type: T.Type, from data: Data?) throws -> T where T : Decodable
    {
        do
        {
            guard let data = data else { throw JSONParsingError.noData }
            let result = try decoder.decode(type.self, from: data)
            return result
        }
        catch DecodingError.dataCorrupted(let context)
        {
            throw JSONParsingError.dataCorrupted
        }
        catch DecodingError.keyNotFound(let key, let context)
        {
            throw JSONParsingError.keyNotFound(key: key.stringValue)
        }
        catch DecodingError.valueNotFound(let value, let context)
        {
            throw JSONParsingError.valueNotFound(value: "\(value)")
        }
        catch DecodingError.typeMismatch(let type, let context)
        {
            throw JSONParsingError.typeMismatch(type: "\(type)")
        }
        catch
        {
            throw JSONParsingError.other(msg: error.localizedDescription)
        }
    }
}

enum JSONParsingError: LocalizedError
{
    case noData
    case dataCorrupted
    case keyNotFound(key: String)
    case valueNotFound(value: String)
    case typeMismatch(type: String)
    case other(msg: String)
    
    var errorDescription: String?
    {
        switch self {
        case .noData:
            "No data provided"
        case .dataCorrupted:
            "Data currupted"
        case .keyNotFound(let key):
            "Key not found \(key)"
        case .valueNotFound(let value):
            "Value not found \(value)"
        case .typeMismatch(let type):
            "Type mismatch \(type)"
        case .other(let msg):
            msg
        }
    }
}
