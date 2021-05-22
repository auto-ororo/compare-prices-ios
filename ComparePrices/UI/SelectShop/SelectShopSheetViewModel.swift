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
    private(set) var shopSelected = PassthroughSubject<Shop, Never>()
    @Published private var shopList: [Shop] = []
    @Published private(set) var filteredShopList: [Shop] = []
    
    @Published private(set) var isEnabledAddButton: Bool = false
    
    func selectShop(shop: Shop) {
        shopSelected.send(shop)
    }
    
    func observeShops() {
        shopRepository.observeShops()
            .map { $0.filter(\.isEnabled) }
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
    
    func addShop() {
        shopRepository.getShop(searchWord)
            .map { optionalShop -> Shop? in
                optionalShop?.isEnabled == true ? optionalShop : nil
            }
            .flatMap { [weak self] optionalShop -> AnyPublisher<Void, Error> in
                if optionalShop == nil, let shopRepository = self?.shopRepository, let searchWord = self?.searchWord {
                    return shopRepository.addShop(Shop(name: searchWord)).eraseToAnyPublisher()
                } else {
                    return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
            }
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case let .failure(error):
                    print(error)
                case .finished:
                    self?.searchWord.removeAll()
                }
            }, receiveValue: { _ in }).store(in: &cancellables)
    }
    
    func deleteShop(shop: Shop) {
        var disabledShop = shop
        disabledShop.isEnabled = false
        shopRepository.updateShop(disabledShop)
            .sink(receiveCompletion: { result in
                switch result {
                case let .failure(error):
                    print(error)
                case .finished:
                    break
                }
            }, receiveValue: {})
            .store(in: &cancellables)
    }
    
    func validateAddButton() {
        $searchWord.map { !$0.isEmpty }.assign(to: \.isEnabledAddButton, on: self).store(in: &cancellables)
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
