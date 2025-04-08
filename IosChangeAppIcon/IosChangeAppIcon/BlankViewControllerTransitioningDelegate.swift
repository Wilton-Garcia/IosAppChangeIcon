//
//  BlankViewControllerTransitioningDelegate.swift
//  IosChangeAppIcon
//
//  Created by Wilton Garcia on 08/04/25.
//

import UIKit


class BlankViewControllerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        BlankPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
