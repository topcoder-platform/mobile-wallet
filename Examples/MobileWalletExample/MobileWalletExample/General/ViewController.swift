//
//  ViewController.swift
//  MobileWalletExample
//
//  Created by Volkov Alexander on 1/28/21.
//  Copyright © 2021 Topcoder. All rights reserved.
//

import UIKit
import Combine
import vcx

class ViewController: UIViewController {

    var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        VcxLogger.setDefault(nil)
        
        do {
            CMConfig.shared.environment = .staging
            CMConfig.shared.walletName = "StagingKey"
//            CMConfig.shared.walletKey = "...<put key here if you are using the same key on other device>"
//            CMConfig.shared.poolName = "<put pool name if you know it>"
        }
        do {
            CMConfig.shared.environment = .demo
            CMConfig.shared.walletName = "DemoKey"
//            CMConfig.shared.walletKey = "...<put key here if you are using the same key on other device>"
        }
        cancellable = CMConfig.shared.initialize()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Can be used further
                    break
                case .failure(let error):
                    // Process initialization error
                    print(error)
                }
            }, receiveValue: { _ in })
    }
}

func showError(errorMessage: String) {
    print("ERROR: \(errorMessage)")
}

extension UIViewController {
    
    private func connect(withInvitation invitation: Dictionary<String, Any>) -> AnyCancellable {
        var connectionHandle: Int!
        let util = VcxUtil()
        // Creating a connection
        return util.connect(withInviteDetails: invitation)
            .flatMap({ handle -> Future<Void, Error> in
                connectionHandle = handle
                return util.connect(handle: handle)
            })
            .map { _ in
                sleep(4)
        }
        .flatMap({ handle in
            util.connectionGetState(handle: connectionHandle)
        })
            .flatMap({ handle in
                util.connectionUpdateState(handle: connectionHandle)
            })
            .flatMap({ _ in
                util.connectionSerialize(handle: connectionHandle)
            })
            .map { [weak self] serializedConnection in
                _ = util.connectionRelease(handle: connectionHandle)
                guard self != nil else { return }
                
                // Update UI connection
                print("CONNECTED: " + invitation.description)
        }
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished: break
            case .failure(let error): showError(errorMessage: error.localizedDescription)
            }
        }, receiveValue: { _ in })
    }
}
