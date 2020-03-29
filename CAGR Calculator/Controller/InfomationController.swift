//
//  InfomationController.swift
//  CAGR Calculator
//
//  Created by Phan Đăng on 3/17/20.
//  Copyright © 2020 Phan Nhat Dang. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class InfomationController: UIViewController , MFMailComposeViewControllerDelegate,SKPaymentTransactionObserver {

    @IBOutlet weak var removeAdsView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var resourceView: UIView!
    @IBOutlet weak var NPVView: UIView!
    @IBOutlet weak var autoLoanView: UIView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        
       
        navigationController?.navigationBar.isTranslucent = false
        
        SKPaymentQueue.default().add(self)
        
        
        let weChartTap = UITapGestureRecognizer(target: self, action: #selector(openAutoLoan))
        autoLoanView.addGestureRecognizer(weChartTap)
        
        let saveMoneyTap = UITapGestureRecognizer(target: self, action: #selector(openNPVCalculator))
        NPVView.addGestureRecognizer(saveMoneyTap)
        
        let reportTap = UITapGestureRecognizer(target: self, action: #selector(sentMail))
        reportView.addGestureRecognizer(reportTap)
        
        let resourceTap = UITapGestureRecognizer(target: self, action: #selector(showResource))
        resourceView.addGestureRecognizer(resourceTap)
        
        let removeAdsTap = UITapGestureRecognizer(target: self, action: #selector(removeAds))
        removeAdsView.addGestureRecognizer(removeAdsTap)
        
       
    }
    
    
    @objc func removeAds() {
        if !defaults.bool(forKey: "isRemoveAds") {
            AlertService.showInfoAlertAndComfirm(in: self, title: StringForLocal.removeAds, message: StringForLocal.removeAdsAndSupporting) {isOK in
                if isOK {
                    if SKPaymentQueue.canMakePayments() {
                        let paymentRequest = SKMutablePayment()
                        paymentRequest.productIdentifier = "PhanNhatDang.CAGRCalculator.RemoveAds"
                        SKPaymentQueue.default().add(paymentRequest)
                    }else {
                        print("User unable to make payments")
                    }
                }else {
                    SKPaymentQueue.default().restoreCompletedTransactions()
                }
                
            }
            return
        }
        
    }
    
    

    @objc func showResource() {
        AlertService.showInfoAlert(in: self, title: "Resource", message: "Icons: www.icons8.com")
        
    }
    
    @objc func openNPVCalculator() {
        if let url = URL(string: "https://apps.apple.com/us/app/npv-calculator-by-nd/id1496500153"),
            UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func openAutoLoan() {
        if let url = URL(string: "https://apps.apple.com/us/app/auto-loan-calculator-payment/id1487930075"),
            UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["phannhatd@gmail.com"])
        mailComposerVC.setSubject("Question about CAGR Calculator")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Unable to send mail", message: "Your device cannot send mail", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @objc func sentMail() {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                defaults.set(true, forKey: "isRemoveAds")
                print("Transaction successful")
                SKPaymentQueue.default().finishTransaction(transaction)
            }else if transaction.transactionState == .failed {
                print("Transaction failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            }else if transaction.transactionState == .restored {
                defaults.set(true, forKey: "isRemoveAds")
                print("Transaction successful")
                SKPaymentQueue.default().finishTransaction(transaction)
                print("ReStore ok")
            }
        }
    }

}
