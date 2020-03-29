//
//  ReferenceController.swift
//  CAGR Calculator
//
//  Created by Phan Đăng on 3/17/20.
//  Copyright © 2020 Phan Nhat Dang. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ReferenceController: UIViewController,GADBannerViewDelegate {
    
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var heightFromInputToResultContraint: NSLayoutConstraint!
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        definitionLabel.text = StringForLocal.definitionText
        if !defaults.bool(forKey: "isRemoveAds"){
            bannerView.delegate = self
            bannerView.adUnitID = "ca-app-pub-9626752563546060/1649757629"
            //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //Sample
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if defaults.bool(forKey: "isRemoveAds"){
            self.bannerView.isHidden = true
            self.heightFromInputToResultContraint.constant = 0
        }
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        UIView.animate(withDuration: 1, animations: {
            self.heightFromInputToResultContraint.constant = 70
        })
    }
    


}
