//
//  SelectShopSheetViewModel.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/21.
//

import Foundation
import Combine

final class SelectShopSheetViewModel : ObservableObject, Identifiable {
    
    @Injected private var shopRepository: ShopRepository
    
    private var cancellables: [AnyCancellable] = []
    
    @Published var searchWord : String = ""
    private(set) var shopSelected = PassthroughSubject<Shop, Never>()
    @Published private var shopList : [Shop] = []
    @Published private(set) var filteredShopList : [Shop] = []
    
    func selectShop(shop : Shop) {
        shopSelected.send(shop)
    }
    
    func getShops() {
        shopRepository.getShops()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print(error)
                default:
                    break
                }
            }) { shops in
                self.shopList = shops
            }.store(in: &cancellables)
    }
    
    func addShop() {
        let uuid = UUID()
        shopRepository.addShop(Shop(id: uuid,name: searchWord))
            .compactMap{ [weak self] _ in
                self?.shopRepository.getShop(uuid)
            }.flatMap{$0}
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print(error)
                default:
                    break
                }
            }, receiveValue: { [weak self]  shop in
                self?.shopSelected.send(shop)
            })
            .store(in: &cancellables)
    }
    
    func filterShopListFromSearchWord() {
        self.$shopList.combineLatest($searchWord).map{ (commodities, searchWord) in
            if searchWord.isEmpty { return commodities }
            return commodities.filter{ $0.name.contains(searchWord) }
        }.assign(to: \.filteredShopList, on: self).store(in: &cancellables)
    }
    
    init() {
        filterShopListFromSearchWord()
    }
}
