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
    private(set) var commoditySelected = PassthroughSubject<Commodity, Never>()
    @Published private var commodityList: [Commodity] = []
    @Published private(set) var filteredCommodityList: [Commodity] = []
    
    @Published private(set) var isEnabledAddButton: Bool = false
    
    func selectCommodity(commodity: Commodity) {
        commoditySelected.send(commodity)
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
        commodityRepository.getCommodity(name: searchWord).flatMap { [weak self] optionalCommodity -> AnyPublisher<Commodity?, Error> in
            if let commodity = optionalCommodity {
                return Just(commodity).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
                
            if let commodityRepository = self?.commodityRepository, let searchWord = self?.searchWord {
                let newCommodity = Commodity(name: searchWord)
                return commodityRepository.addCommodity(newCommodity).map { _ in newCommodity }.eraseToAnyPublisher()
                
            } else {
                return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
        }
        .sink(receiveCompletion: { result in
            switch result {
            case let .failure(error):
                print(error)
            default:
                break
            }
        }, receiveValue: { [weak self] optionalCommodity in
            if let commodity = optionalCommodity {
                self?.commoditySelected.send(commodity)
            }
        }).store(in: &cancellables)
    }
    
    func validateAddButton() {
        $searchWord.map { !$0.isEmpty }.assign(to: \.isEnabledAddButton, on: self).store(in: &cancellables)
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
