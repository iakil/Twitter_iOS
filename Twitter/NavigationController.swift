//
//  NavigationController.swift
//  Twitter
//
//  Created by Akil Bhuiyan on 10/2/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import Foundation
import UIKit
class NavigationController : UINavigationController
{
    fileprivate var originaBarDelegate:UINavigationBarDelegate?
    private var forwarder:Forwarder? = nil

    var navigationBarDelegate:UINavigationBarDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if navigationBar.delegate != nil {
            forwarder = Forwarder(self)
        }
    }
}

fileprivate class Forwarder : NSObject, UINavigationBarDelegate {

    weak var controller:NavigationController?

    init(_ controller: NavigationController) {
        self.controller = controller
        super.init()

        controller.originaBarDelegate = controller.navigationBar.delegate
        controller.navigationBar.delegate = self
    }

    let shouldPopSel = #selector(UINavigationBarDelegate.navigationBar(_:shouldPop:))
    let didPopSel = #selector(UINavigationBarDelegate.navigationBar(_:didPop:))
    let shouldPushSel = #selector(UINavigationBarDelegate.navigationBar(_:shouldPush:))
    let didPushSel = #selector(UINavigationBarDelegate.navigationBar(_:didPush:))

    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if let delegate = controller?.navigationBarDelegate, delegate.responds(to: shouldPopSel) {
            if !delegate.navigationBar!(navigationBar, shouldPop: item) {
                return false
            }
        }

        if let delegate = controller?.originaBarDelegate, delegate.responds(to: shouldPopSel) {
            return delegate.navigationBar!(navigationBar, shouldPop: item)
        }

        return true
    }

    func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        if let delegate = controller?.navigationBarDelegate, delegate.responds(to: didPopSel) {
            delegate.navigationBar!(navigationBar, didPop: item)
        }

        if let delegate = controller?.originaBarDelegate, delegate.responds(to: didPopSel) {
            return delegate.navigationBar!(navigationBar, didPop: item)
        }
    }

    func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        if let delegate = controller?.navigationBarDelegate, delegate.responds(to: shouldPushSel) {
            if !delegate.navigationBar!(navigationBar, shouldPush: item) {
                return false
            }
        }

        if let delegate = controller?.originaBarDelegate, delegate.responds(to: shouldPushSel) {
            return delegate.navigationBar!(navigationBar, shouldPush: item)
        }

        return true
    }

    func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        if let delegate = controller?.navigationBarDelegate, delegate.responds(to: didPushSel) {
            delegate.navigationBar!(navigationBar, didPush: item)
        }

        if let delegate = controller?.originaBarDelegate, delegate.responds(to: didPushSel) {
            return delegate.navigationBar!(navigationBar, didPush: item)
        }
    }
}
