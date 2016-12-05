//
//  ViewControllerExtensions.swift
//  HomeKitDemo
//
//  Created by Vlad on 11/27/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit

protocol Layoutable {
    func layout()
}

extension UIViewController {
    static var storyboardInstance: UIViewController {
        return storyboardInstance(withTitle: "")
    }

    static func storyboardInstance(withTitle title: String) -> UIViewController {
        let classNameWithoutModule = NSStringFromClass(self).components(separatedBy: ".").last!
        let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: classNameWithoutModule)
        viewController.title = title
        return viewController
    }

    var topGuide: UIView {
        return self.topLayoutGuide as! UIView
    }

    var bottomGuide: UIView {
        return self.bottomLayoutGuide as! UIView
    }
}

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
