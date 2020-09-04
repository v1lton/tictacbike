//
//  SpinnerViewController.swift
//  tictacbike
//
//  Created by Juliano Vaz on 04/09/20.
//  Copyright © 2020 Wilton Ramos. All rights reserved.
//

import Foundation
import UIKit

class SpinnerViewController: UIViewController {


    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.0)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
