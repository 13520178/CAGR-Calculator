//
//  GrowthTableController.swift
//  CAGR Calculator
//
//  Created by Phan Đăng on 3/17/20.
//  Copyright © 2020 Phan Nhat Dang. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GrowthTableController: UIViewController,UITableViewDataSource, UITableViewDelegate,GADBannerViewDelegate {
   
    
    
    @IBOutlet weak var heightFromInputToResultContraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    
    
    var years = [Year]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if !defaults.bool(forKey: "isRemoveAds"){
            bannerView.delegate = self
            bannerView.adUnitID = "ca-app-pub-9626752563546060/7413768939"
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return years.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "growthCell") as! GrowthTableCell
        cell.yearOrMonthLabel.text = String(years[indexPath.row].numOfYear)
        cell.valueLabel.text = "\(StringForLocal.unit) \(Tools.changeToCurrency(moneyStr: years[indexPath.row].value)!)"
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
       
    
}
