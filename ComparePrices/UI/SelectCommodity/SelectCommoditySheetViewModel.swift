//
//  SelectCommoditySheetViewModel.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/16.
//

import Combine
import Foundation

final class SelectCommoditySheetViewModel: ObservableObject, Identifiable {
    @Injected private var commodityRepository: CommodityRepository
    
    private var cancellables: [AnyCancellable] = []
    
    @Published var searchWord: String = ""
    private(set) var commoditySelected = PassthroughSubject<(commodity: Commodity, isNew: Bool), Never>()
    @Published private var commodityList: [Commodity] = []
    @Published private(set) var filteredCommodityList: [Commodity] = []
    
    @Published private(set) var isEnabledAddButton: Bool = false
    
    func selectCommodity(commodity: Commodity) {
        commoditySelected.send((commodity: commodity, isNew: false))
    }
    
    func getCommodities() {
        commodityRepository.getCommodities()
            .sink(receiveCompletion: { result in
                      switch result {
                      case let .failure(error):
                          print(error)
                      default:
                          break
                      }
                  },
                  receiveValue: { commodities in
                      self.commodityList = commodities
                  })
            .store(in: &cancellables)
    }
    
    func selectNewCommodity() {
        commodityRepository.getCommodity(name: searchWord)
            .sink(receiveCompletion: { result in
                switch result {
                case let .failure(error):
                    print(error)
                default:
                    break
                }
            }, receiveValue: { [weak self] optionalCommodity in
                if let commodity = optionalCommodity {
                    self?.commoditySelected.send((commodity: commodity, isNew: false))
                } else {
                    guard let searchWord = self?.searchWord else { return }
                    self?.commoditySelected.send((commodity: Commodity(name: searchWord), isNew: true))
                }
            }).store(in: &cancellables)
    }
    
    func validateAddButton() {
        $searchWord.map(\.isEmpty).assign(to: \.isEnabledAddButton, on: self).store(in: &cancellables)
    }

    func filterCommodityListFromSearchWord() {
        $commodityList.combineLatest($searchWord).map { commodities, searchWord in
            if searchWord.isEmpty { return commodities }
            return commodities.filter { $0.name.contains(searchWord) }
        }.assign(to: \.filteredCommodityList, on: self).store(in: &cancellables)
    }
    
    init() {
        validateAddButton()
        filterCommodityListFromSearchWord()
    }
}
