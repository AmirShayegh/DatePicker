//
//  UIViewController.swift
//  Extended
//
//  Created by Amir Shayegh on 2018-09-26.
//

import Foundation
import Foundation
import UIKit

extension UIViewController {

    ///Make sure storyboard file has same name as the class name
    public static func storyboardInstance() -> UIViewController?{
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        let controller = storyboard.instantiateInitialViewController()
        return controller
    }

    public func showAlert(with title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        ac.addAction(cancel)

        present(ac, animated: true, completion: nil)
    }
}

