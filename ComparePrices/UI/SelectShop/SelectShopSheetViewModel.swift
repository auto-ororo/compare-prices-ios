//
//  SelectShopSheetViewModel.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/21.
//

import Combine
import Foundation

final class SelectShopSheetViewModel: ObservableObject, Identifiable {
    @Injected private var shopRepository: ShopRepository
    
    private var cancellables: [AnyCancellable] = []
    
    @Published var searchWord: String = ""
    private(set) var shopSelected = PassthroughSubject<(shop: Shop, isNew: Bool), Never>()
    @Published private var shopList: [Shop] = []
    @Published private(set) var filteredShopList: [Shop] = []
    
    @Published private(set) var isEnabledAddButton: Bool = false
    
    func selectShop(shop: Shop) {
        shopSelected.send((shop: shop, isNew: false))
    }
    
    func getShops() {
        shopRepository.getShops()
            .sink(receiveCompletion: { result in
                      switch result {
                      case let .failure(error):
                          print(error)
                      default:
                          break
                      }
                  },
                  receiveValue: { shops in
                      self.shopList = shops
                  })
            .store(in: &cancellables)
    }
    
    func selectNewShop() {
        shopRepository.getShop(searchWord)
            .sink(receiveCompletion: { result in
                switch result {
                case let .failure(error):
                    print(error)
                default:
                    break
                }
            }, receiveValue: { [weak self] optionalShop in
                if let shop = optionalShop {
                    self?.shopSelected.send((shop: shop, isNew: false))
                } else {
                    guard let searchWord = self?.searchWord else { return }
                    self?.shopSelected.send((shop: Shop(name: searchWord), isNew: true))
                }
            }).store(in: &cancellables)
    }
    
    func validateAddButton() {
        $searchWord.map(\.isEmpty).assign(to: \.isEnabledAddButton, on: self).store(in: &cancellables)
    }

    func filterShopListFromSearchWord() {
        $shopList.combineLatest($searchWord).map { commodities, searchWord in
            if searchWord.isEmpty { return commodities }
            return commodities.filter { $0.name.contains(searchWord) }
        }.assign(to: \.filteredShopList, on: self).store(in: &cancellables)
    }
    
    init() {
        validateAddButton()
        filterShopListFromSearchWord()
    }
}
