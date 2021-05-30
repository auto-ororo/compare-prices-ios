//
//  CommodityListViewModel.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/31.
//

import Combine
import Foundation

final class CommodityListViewModel: ObservableObject, Identifiable {
    @Injected private var commodityRepository: CommodityRepository
    @Injected private var purchaseResultRepository: PurchaseResultRepository
    @Injected private var shopRepository: ShopRepository
    
    private var cancellables: [AnyCancellable] = []
    
    @Published var searchWord: String = ""
    @Published private var commodityList: [CommodityListRow] = []
    @Published private(set) var filterdAndSortedList: [CommodityListRow] = []
    
    @Published var sortType: SortType = .date
    private var sortTypeChanged = PassthroughSubject<Void, Never>()
    
    enum SortType: Hashable {
        case date
        case commodity
        case shop
    }
    
    func getCommodities() {
        var list: [CommodityListRow] = []
        
        // ユーザーが登録した商品リスト、及び各商品の最安値・購入店を取得
        commodityRepository.getAllCommodities()
            .map { $0.filter(\.isEnabled) }
            .flatMap(\.publisher)
            .flatMap { commodity in
                Publishers.Zip3(
                    self.purchaseResultRepository.getLowestPricePurchaseResult(commodity.id),
                    self.purchaseResultRepository.getNewestPurchaseResult(commodity.id),
                    Just(commodity).setFailureType(to: Error.self)
                )
            }
            .flatMap { result1, result2, commodity -> AnyPublisher<CommodityListRow?, Error> in
                guard let result1 = result1, let result2 = result2, result1.isEnabled, result2.isEnabled else {
                    return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                
                return self.shopRepository.getShop(result1.shopId)
                    .filter(\.isEnabled)
                    .map { shop in
                        CommodityListRow(commodity: commodity, lowestPrice: result1.price, mostInexpensiveShop: shop, lastPurchaseDate: result2.purchaseDate)
                    }.eraseToAnyPublisher()
            }
            .compactMap { $0 }
            .sink(
                receiveCompletion: { [weak self] result in
                    switch result {
                    case let .failure(error):
                        print(error)
                    case .finished:
                        self?.commodityList = list
                    }
                },
                receiveValue: { commodity in
                    list.append(commodity)
                }
            ).store(in: &cancellables)
    }
    
    func notifySortTypeChanged() {
        sortType = sortType
    }
    
    private func filterAndSortCommodityList() {
        Publishers.CombineLatest3($commodityList, $searchWord, $sortType).map { [weak self] commodities, searchWord, _ in
            var filterdAndSortedList: [CommodityListRow]
            
            if searchWord.isEmpty {
                filterdAndSortedList = commodities
            } else {
                filterdAndSortedList = commodities.filter { $0.commodity.name.contains(searchWord) || $0.mostInexpensiveShop.name.contains(searchWord) }
            }

            guard let sortType = self?.sortType else { return filterdAndSortedList }
            
            switch sortType {
            case .commodity:
                filterdAndSortedList.sort { $0.commodity.name < $1.commodity.name }
            case .shop:
                filterdAndSortedList.sort { $0.mostInexpensiveShop.name < $1.mostInexpensiveShop.name }
            case .date:
                filterdAndSortedList.sort { $0.lastPurchaseDate > $1.lastPurchaseDate }
            }
            
            return filterdAndSortedList
        }
        .assign(to: \.filterdAndSortedList, on: self).store(in: &cancellables)
    }
    
    init() {
        filterAndSortCommodityList()
    }
}
