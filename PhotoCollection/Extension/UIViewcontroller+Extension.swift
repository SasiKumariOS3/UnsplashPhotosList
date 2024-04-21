//
//  UIViewcontroller+Extension.swift
//  PhotoCollection
//
//  Created by SasikumarSubramaniyam on 21/04/24.
//

import Foundation
import UIKit

// MARK: - UIViewController Extension
extension UIViewController {
    
    // This function used to show the alet view with the title and message
    func showAlertMessage(with title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Constants.ok, style: .cancel) { [weak self] (alert) in
            self?.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(alertAction)
        self.present(alertView, animated: true)
    }
    
}
