//
//  CommodityListViewModel.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/01/31.
//

import Foundation
import Combine

final class CommodityListViewModel : ObservableObject, Identifiable {
    
    @Injected private var commodityRepository: CommodityRepository
    @Injected private var commodityPriceRepository: CommodityPriceRepository
    @Injected private var shopRepository: ShopRepository
    
    private var cancellables: [AnyCancellable] = []
    
    @Published var searchWord : String = ""
    @Published private var commodityList : [CommodityListRow] = []
    @Published private(set) var filteredCommodityList : [CommodityListRow] = []
    
    func getCommodities() {
        var list : [CommodityListRow] = []
        
        // ユーザーが登録した商品リスト、及び各商品の最安値・購入店を取得
        commodityRepository.getCommodities()
            .flatMap{ (commodities) in commodities.publisher }
            .compactMap { [weak self] commodity in
                self?.commodityPriceRepository.getLowestCommodityPrice(commodity.id).compactMap{$0}
                    .compactMap { [weak self] commodityPrice in
                        self?.shopRepository.getShop(commodityPrice.shopId).flatMap{ shop in
                            Just(CommodityListRow(commodity: commodity, lowestPrice: commodityPrice.price, mostInexpensiveShop: shop))
                        }
                    }.flatMap{$0}
            }.flatMap{$0}
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .finished:
                    self?.commodityList = list
                }
            }) { commodity in
                list.append(commodity)
            }.store(in: &cancellables)
    }
    
    func filterCommodityListFromSearchWord() {
        self.$commodityList.combineLatest($searchWord).map{ (commodities, searchWord) in
            if searchWord.isEmpty { return commodities }
            return commodities.filter{ $0.commodity.name.contains(searchWord) || $0.mostInexpensiveShop.name.contains(searchWord) }
        }.assign(to: \.filteredCommodityList, on: self).store(in: &cancellables)
    }
    
    init() {
        filterCommodityListFromSearchWord()
    }
}
