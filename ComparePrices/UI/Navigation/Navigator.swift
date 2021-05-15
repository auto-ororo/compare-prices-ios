//
//  Navigator.swift
//  ComparePrices
//
//  Created by ororo on 2021/04/29.
//

import Foundation
import SwiftUI

enum MoveTo: Equatable {
    case none
    case splash
    case commodityList
    case addCommodity
    case commodityDetail(Commodity)
    case addPurchaseResult(Commodity?)
    
    static func == (lhs: MoveTo, rhs: MoveTo) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.splash, .splash):
            return true
        case (.commodityList, .commodityList):
            return true
        case (.addCommodity, .addCommodity):
            return true
        case let (.commodityDetail(commodity1), .commodityDetail(commodity2)):
            return commodity1 == commodity2
        case let (.addPurchaseResult(commodity1), .addPurchaseResult(commodity2)):
            return commodity1 == commodity2
        default:
            return false
        }
    }
}

enum Direction {
    case splash
    case first
    case next
    case back
}

struct NavigationRequest {
    var moveTo: MoveTo
    var direction: Direction
}

class Navigator: ObservableObject {
    @Published private(set) var request = NavigationRequest(moveTo: .splash, direction: .splash)
    
    private var stack: [NavigationRequest] = []
    
    func navigate(to: MoveTo, direction: Direction) {
        stack.append(request)
        request = NavigationRequest(moveTo: to, direction: direction)
    }
    
    func getLastStack() -> NavigationRequest {
        guard let req = stack.last else {
            fatalError("スタックが存在しない")
        }
        
        return req
    }

    func getTransitionAnimation() -> AnyTransition {
        switch request.direction {
        case .splash:
            return .asymmetric(insertion: .identity, removal: .opacity)
        case .first:
            return .asymmetric(insertion: .opacity, removal: .move(edge: .leading))
        case .next:
            return .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        case .back:
            return .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
        }
    }
    
    init() {
        stack.append(request)
    }
}
