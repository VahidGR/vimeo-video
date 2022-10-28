//
//  AuthenticationViewModel.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/27/22.
//

import VimeoNetworking
import RxRelay

struct AuthenticationViewModel {
    
    var error = BehaviorRelay<String?>(value: nil)
    
    private func fetch(authenticationController: AuthenticationController, completion: @escaping (() -> ())) {
        
        authenticationController.clientCredentialsGrant { result in
            
            switch result {
            case .success(let account):
                print("Successfully authenticated with account: \(account)")
                PreferencesService().setOnboarded()
                completion()
            case .failure(let error):
                PreferencesService().setNotOnboarded()
                self.error.accept(error.localizedDescription)
            }
        }
        
    }
    
    func configureVimeo(completion: @escaping (() -> ())) {
        
        let clientIdentifier = SecretReader.value(for: .clientIdentifier)
        let clientSecrets = SecretReader.value(for: .clientSecret)
        
        let appConfiguration = AppConfiguration(
            clientIdentifier: clientIdentifier,
            clientSecret: clientSecrets,
            scopes: [.Public, .Private, .Interact, .Stats, .VideoFiles],
            keychainService: "KeychainServiceVimeo"
        )
        VimeoClient.configureSharedClient(
            withAppConfiguration: appConfiguration,
            configureSessionManagerBlock: nil
        )
        let authenticationController = AuthenticationController(
            client: VimeoClient.sharedClient,
            appConfiguration: appConfiguration,
            configureSessionManagerBlock: nil
        )
        
        fetch(authenticationController: authenticationController) {
            completion()
        }
        
    }
    
}
