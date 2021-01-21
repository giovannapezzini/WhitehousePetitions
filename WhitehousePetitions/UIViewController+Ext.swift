//
//  UIViewController+Ext.swift
//  WhitehousePetitions
//
//  Created by Giovanna Pezzini on 12/01/21.
//

import UIKit

extension UIViewController {
    func showError(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(ac, animated: true)
        }
    }
}
