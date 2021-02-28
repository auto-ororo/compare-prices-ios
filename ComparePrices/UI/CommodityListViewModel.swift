//
//  CommodityListViewModel.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/31.
//

import Foundation
import Combine

final class CommodityListViewModel : ObservableObject, Identifiable {
    
    @Injected var commodityRepository: CommodityRepository

    private var cancellables: [AnyCancellable] = []
    
    @Published var commodities : [Commodity]
    
    @Published var filteredCommodities : [Commodity]
    
    @Published var searchWord : String = ""

    func addCommotity() {
        commodityRepository.addCommodity(Commodity(name: "追加", price: Int.random(in: 100...300), store: "store")).sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                print(error)
            default:
                break
            }
        }){}.store(in: &cancellables)
    }
    
    func removeCommodity(commodity: Commodity) {
        commodityRepository.removeCommodity(commodity).sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                print(error)
            default:
                break
            }
        }){}.store(in: &cancellables)
    }
    
    func observeCommodities() {
        self.commodityRepository.observeCommodities().sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                print(error)
            default:
                break
            }
        }) { [weak self] commodities in
            self?.commodities = commodities
        }.store(in: &cancellables)
        
        self.$commodities.combineLatest($searchWord).map{ (commodities, searchWord) in
            if searchWord.isEmpty { return commodities }
            return commodities.filter{ $0.name.contains(searchWord) || $0.store.contains(searchWord) }
        }.assign(to: \.filteredCommodities, on: self).store(in: &cancellables)
    }

    init() {
        self.commodities = []
        self.filteredCommodities = []
    }
}
