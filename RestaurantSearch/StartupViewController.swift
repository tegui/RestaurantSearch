//
//  StartupViewController.swift
//  RestaurantSearch
//
//  Created by Julian Amortegui on 10/13/19.
//  Copyright © 2019 Julian Amortegui. All rights reserved.
///** tegui.me **/

import UIKit

class StartupViewController: UIViewController {

    private enum ControlConfig {
        static let missingZomatoApiKey  = "ADD_ZOMATO_API_KEY"
        static let missingApiKeyTitle   = "MISSING API KEY"
        static let missingApiKeyMsg     = "Don't forget to add the Zomato API key and build it again"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard ZomatoApi.apiKey != ControlConfig.missingZomatoApiKey else {
            showMissingApiKeyAlert()
            return
        }
        
        launchMainAppViewController()
    }
    
    private func launchMainAppViewController() {
        let mainView = RestaurantSearchViewController(nibName: RestaurantSearchViewController.reuseIdentifier, bundle: nil)
        let navigation = UINavigationController(rootViewController: mainView)
        navigation.modalPresentationStyle = .fullScreen
        
        present(navigation, animated: true, completion: nil)
    }
    
    private func showMissingApiKeyAlert() {
        let alert = UIAlertController(title: ControlConfig.missingApiKeyTitle,
                                      message: ControlConfig.missingApiKeyMsg,
                                      preferredStyle: .alert)
        
        
        present(alert, animated: true, completion: nil)
    }
}

