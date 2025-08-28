//
//  CoreDataLogger.swift
//  MovieApp
//
 //  Created by Ahmed Raslan on 27/08/2025.
 


enum CoreDataLogger {
    static func info(_ message: String) {
       #if DEBUG
        print("ℹ️ [INFO] \(message)")
        #endif

    }
    
    static func error(_ message: String) {
        #if DEBUG
        print("❌ [ERROR] \(message)")
        #endif
    }
    
    static func success(_ message: String) {
        #if DEBUG
        print("✅ [SUCCESS] \(message)")
        #endif
    }
}

