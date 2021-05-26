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
    
    func observeCommodities() {
        commodityRepository.observeAllCommodities()
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
    
    func addCommodity() {
        commodityRepository.getCommodity(name: searchWord)
            .flatMap { [weak self] optionalCommodity -> AnyPublisher<Void, Error> in
                if optionalCommodity == nil, let commodityRepository = self?.commodityRepository, let searchWord = self?.searchWord {
                    return commodityRepository.addCommodity(Commodity(name: searchWord)).eraseToAnyPublisher()
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
    
    func deleteCommodity(commodity: Commodity) {
        commodityRepository.deleteCommodity(commodity)
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
