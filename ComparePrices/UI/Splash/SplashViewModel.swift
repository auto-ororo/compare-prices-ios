//
//  SplashViewModel.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/03.
//

import Combine
import Foundation

final class SplashViewModel: ObservableObject {
    @Injected private var authRepository: AuthRepository
    
    private(set) var initializationFinished = PassthroughSubject<Void, Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    func startInitialization() {
        if authRepository.isAuthenticated() {
            initializationFinished.send(())
            return
        }
        
        authRepository.signInAnonymously()
            .sink(
                receiveCompletion: { [weak self] result in
                    switch result {
                    case .finished:
                        self?.initializationFinished.send(())
                    case let .failure(error):
                        print(error)
                    }
                    
                },
                receiveValue: {}
            )
            .store(in: &cancellables)
    }
}
