//
//  UIViewController + extension.swift
//  ITAcademy_SecretStorage
//
//  Created by Влад Муравьев on 09.06.2024.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, message: String?, destruct: String? = K.ok, cancel: String? = K.cancel, handlerDestruct: @escaping () -> Void, handlerCancel: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let destructiveAction = UIAlertAction(title: destruct, style: .destructive) { _ in
            handlerDestruct()
        }
        alert.addAction(destructiveAction)
        
        let cancelAction = UIAlertAction(title: cancel, style: .cancel) { _ in
            handlerCancel()
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
}
