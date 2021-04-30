//
//  Environment.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/01.
//

enum Environment {
    enum FlaverType {
        case develop
        case production
    }

    enum BuildType {
        case debug
        case release
    }

    static func getFlaverType() -> FlaverType {
        #if DEVELOP_DEBUG
            return .develop
        #elseif DEVELOP_RELEASE
            return .develop
        #elseif PRODUCTION
            return .production
        #endif
    }

    static func getBuildType() -> BuildType {
        #if DEVELOP_DEBUG
            return .debug
        #elseif DEVELOP_RELEASE
            return .release
        #elseif PRODUCTION
            return .release
        #endif
    }
}
