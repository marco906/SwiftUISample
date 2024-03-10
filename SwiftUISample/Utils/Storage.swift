//
//  Storage.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 10/03/2024.
//

import Foundation

protocol Store {
    func getBool(forKey key: String) throws -> Bool
    func getInt(forKey key: String) throws -> Int
    func getDouble(forKey key: String) throws -> Double
    func getString(forKey key: String) throws -> String
    
    func set(_ value: Any?, forKey key: String) throws
    
    func setJSONObject<T: Encodable>(_ value: T, forKey key: String) throws
    func getJSONObject<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T
    
    func remove(key: String)
}

class DefaultsStore: Store {
    private var store: UserDefaults
    let parser = JSONParser()
    let encoder = JSONEncoder()
    
    static let shared = DefaultsStore()
    
    init(domain: String? = nil) {
        if let domain = domain {
            store = UserDefaults(suiteName: domain) ?? UserDefaults.standard
        } else {
            store = UserDefaults.standard
        }
    }
    
    func set(_ value: Any?, forKey key: String) throws {
        store.set(value, forKey: key)
    }
    
    func getBool(forKey key: String) throws -> Bool {
        try getObjectAs(Bool.self, forKey: key)
    }
    
    func getInt(forKey key: String) throws -> Int {
        try getObjectAs(Int.self, forKey: key)
    }
    
    func getDouble(forKey key: String) throws -> Double {
        try getObjectAs(Double.self, forKey: key)
    }
    
    func getString(forKey key: String) throws -> String {
        try getObjectAs(String.self, forKey: key)
    }
    
    func setJSONObject<T>(_ value: T, forKey key: String) throws where T : Encodable {
        let jsonData = try encoder.encode(value)
        store.set(jsonData, forKey: key)
    }
    
    func getJSONObject<T>(_ type: T.Type, forKey key: String) throws -> T where T : Decodable {
        let data = try getObjectAs(Data.self, forKey: key)
        let object = try parser.decodeType(type, from: data)
        return object
    }
    
    func remove(key: String) {
        store.removeObject(forKey: key)
    }
    
    private func getObject(forKey key: String) throws -> Any {
        guard let object = store.object(forKey: key) else {
            throw StorageError.keyNotFound
        }
        return object
    }
    
    private func getObjectAs<T: Any>(_ type: T.Type, forKey key: String) throws -> T {
        guard let value = try getObject(forKey: key) as? T else {
            throw StorageError.typeMismatch
        }
        return value
    }
}

enum StorageError: LocalizedError {
    case keyNotFound
    case typeMismatch
}
