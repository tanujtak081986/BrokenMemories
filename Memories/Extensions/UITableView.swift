//
//  UITableView.swift
//  Demo
//
//  Created by Arvind Vlk on 04/01/18.
//  Copyright © 2018 Arvind Vlk. All rights reserved.
//

import UIKit
import Foundation

let bgView = UIView()
let topLabel = UILabel()
let bottomLabel = UILabel()
let imageView = UIImageView()
var refreshControl: UIRefreshControl!

extension UITableView {

    
    func addFooterView()  {
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: SwifterSwift.screenWidth, height: 50)
        let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        footerView.backgroundColor = UIColor.clear
        activityIndictor.frame = CGRect(x: SwifterSwift.screenWidth/2-15, y: 10, width: 30, height: 30)
        activityIndictor.hidesWhenStopped = true
        activityIndictor.tag = 10
        footerView.addSubview(activityIndictor)
        activityIndictor.startAnimating()
        self.tableFooterView = footerView

    }
        
    func addPullRefreshController() {
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            refreshControl?.backgroundColor = UIColor.clear
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            refreshControl?.tintColor = UIColor.darkGray
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            self.addSubview(refreshControl!)
        } else {
            // Fallback on earlier versions
        };if #available(iOS 10.0, *) {
            self.addSubview(refreshControl!)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func refreshTableView() {
        self.backgroundView = nil
        tableFooterView = UIView(frame: CGRect.zero)
        if #available(iOS 10.0, *) {
            self.refreshControl?.endRefreshing()
        } else {
            // Fallback on earlier versions
        }
    }

    func emptyBgView(imageName:String = "", top:String = "", bottom:String = "") {
        
        bgView.frame = self.frame
        setupLabels(top: top, bottom: bottom)
        setupImageView(name: imageName)
        bgView.addSubview(imageView)
        bgView.addSubview(topLabel)
        bgView.addSubview(bottomLabel)
        
        self.backgroundView = bgView
        self.isScrollEnabled = false
    }
    
    func setupImageView(name: String) {
        
        imageView.frame = CGRect(x: (bgView.bounds.size.width)/2 - 50, y: (bgView.bounds.size.height)/2 - 150 , width: 100, height: 100)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: name)
        imageView.tintColor = UIColor.clear
    }

    func setupLabels(top: String, bottom: String) {
        
        topLabel.frame = CGRect(x: 20, y: imageView.frame.maxY , width: (bgView.bounds.size.width) - 40, height: 30)
        topLabel.text = top
        topLabel.textColor = UIColor.darkGray
        topLabel.font = R.font.balqis(size: 20)
            //Font(.system, size: .standard(.h1)).instance
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 1

        bottomLabel.frame = CGRect(x: 20, y: topLabel.frame.maxY , width: (bgView.bounds.size.width) - 40, height: 100)
        bottomLabel.text = bottom
        bottomLabel.textColor = UIColor.lightGray
        bottomLabel.font = R.font.balqis(size: 14)
        bottomLabel.numberOfLines = 0
        bottomLabel.textAlignment = .center
    }

}

