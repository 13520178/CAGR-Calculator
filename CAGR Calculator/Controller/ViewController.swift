//
//  ViewController.swift
//  CAGR Calculator
//
//  Created by Phan Nhat Dang on 3/14/20.
//  Copyright © 2020 Phan Nhat Dang. All rights reserved.
//

import UIKit
import Charts
import GoogleMobileAds

class ViewController: UIViewController,UITextFieldDelegate,GADBannerViewDelegate {
    
    @IBOutlet weak var heightFromInputToResultContraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var growthTableButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var startingErrorLabel: UILabel!
    @IBOutlet weak var endingErrorLabel: UILabel!
    @IBOutlet weak var periodErrorLabel: UILabel!
    @IBOutlet weak var pieView: PieChartView!
    @IBOutlet weak var startingValueTextfield: UITextField!
    @IBOutlet weak var endingValueTextfield: UITextField!
    @IBOutlet weak var noOfPeriodsTextfield: UITextField!
    @IBOutlet weak var inputMainView: UIView!
    @IBOutlet weak var inputShadowView: UIView!
    
    @IBOutlet weak var resultMainView: UIView!
    @IBOutlet weak var resultShadowView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    
    //Check all textfield is OK
    var isStartingOk = false
    var isEndingOk = false
    var isPeriodOk = false
    
    var periodToGrowthAndChart = 0
    var startToGrowthAndChart = 0.0
    var endToGrowthAndChart = 0.0
    
    var exactlyResult = 0.0
    var years = [Year]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        startingValueTextfield.delegate = self
        endingValueTextfield.delegate = self
        noOfPeriodsTextfield.delegate = self
        
        if !defaults.bool(forKey: "isRemoveAds"){
            bannerView.delegate = self
            bannerView.adUnitID = "ca-app-pub-9626752563546060/3106309528"
            //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //Sample
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        
        startingValueTextfield.setBottomBorder()
        startingValueTextfield.attributedPlaceholder = NSAttributedString(string:StringForLocal.initialInvestmentValue, attributes:[NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),NSAttributedString.Key.font :UIFont(name: "HelveticaNeue-Bold", size: 20)!])
        
        endingValueTextfield.setBottomBorder()
        endingValueTextfield.attributedPlaceholder = NSAttributedString(string:StringForLocal.endingInvestmentValue, attributes:[NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),NSAttributedString.Key.font :UIFont(name: "HelveticaNeue-Bold", size: 20)!])
        
        noOfPeriodsTextfield.setBottomBorder()
        noOfPeriodsTextfield.attributedPlaceholder = NSAttributedString(string: StringForLocal.monthsYears, attributes:[NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),NSAttributedString.Key.font :UIFont(name: "HelveticaNeue-Bold", size: 20)!])
        
        inputShadowView.layer.shadowColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        inputShadowView.layer.shadowOpacity = 0.5
        inputShadowView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        inputShadowView.layer.shadowRadius = 6
        
        resultShadowView.layer.shadowColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        resultShadowView.layer.shadowOpacity = 0.5
        resultShadowView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        resultShadowView.layer.shadowRadius = 6
        
        growthTableButton.isEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        startingValueTextfield.addTarget(self, action: #selector(startingValueTextFieldDidChange), for: .editingChanged)
        endingValueTextfield.addTarget(self, action: #selector(endingValueTextfieldDidChange), for: .editingChanged)
        noOfPeriodsTextfield.addTarget(self, action: #selector(noOfPeriodsTextfieldDidChange), for: .editingChanged)
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if defaults.bool(forKey: "isRemoveAds"){
            self.bannerView.isHidden = true
            self.heightFromInputToResultContraint.constant = 24
        }
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        UIView.animate(withDuration: 1, animations: {
            self.heightFromInputToResultContraint.constant = 296
        })
    }
    
    
    func setupPieChart(investmentValue:Double, returnValue:Double) {
        pieView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        var entries: [PieChartDataEntry] = Array()
        entries.append(PieChartDataEntry(value: investmentValue, label: StringForLocal.investment))
        entries.append(PieChartDataEntry(value: returnValue, label: StringForLocal.returnText))
        
        let dataSet = PieChartDataSet(entries: entries,label: "")
        
        dataSet.colors = [#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1),#colorLiteral(red: 0.1201359108, green: 0.7289800048, blue: 1, alpha: 1)]
        dataSet.drawValuesEnabled = true
        
        dataSet.sliceSpace = 2.0
        
        
        pieView.usePercentValuesEnabled = true
        pieView.drawSlicesUnderHoleEnabled = false
        pieView.holeRadiusPercent = 0.40
        pieView.transparentCircleRadiusPercent = 0.43
        pieView.drawHoleEnabled = true
        pieView.rotationAngle = 0.0
        pieView.rotationEnabled = true
        pieView.highlightPerTapEnabled = false
        
        let pieChartLegend = pieView.legend
        pieChartLegend.horizontalAlignment = Legend.HorizontalAlignment.right
        pieChartLegend.verticalAlignment = Legend.VerticalAlignment.top
        pieChartLegend.orientation = Legend.Orientation.vertical
        pieChartLegend.drawInside = false
        pieChartLegend.yOffset = 10.0
        
        pieView.legend.enabled = true
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        
        
        let pieChartData = PieChartData(dataSet: dataSet)
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        pieView.data = pieChartData
        
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //0: Nhập số sai
        //1: Âm
        //2: Quá cao
        //-1 : OK
        
        if textField == startingValueTextfield {
            let indexCode = Tools.textDecimalValid(inputText: textField.text!)
            if indexCode != -1 && indexCode != -2 {
                isStartingOk = false
                startingValueTextfield.backgroundColor = #colorLiteral(red: 0.9768655896, green: 0.5316846371, blue: 0.5128982067, alpha: 1)
                startingErrorLabel.isHidden = false
                if indexCode == 1 {
                    startingErrorLabel.text = StringForLocal.cannotBeANegativeNumber
                }else if indexCode == 2{
                    startingErrorLabel.text = StringForLocal.theNumberIsTooBig
                }else if indexCode == 0 {
                    startingErrorLabel.text = StringForLocal.mustBeADecimalNumber
                }
            }else {
                startingValueTextfield.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                startingErrorLabel.isHidden = true
                isStartingOk = true
            }
        }
        
        if textField == endingValueTextfield {
            let indexCode = Tools.textDecimalValid(inputText: textField.text!)
            if indexCode != -1 && indexCode != -2 {
                isEndingOk = false
                endingValueTextfield.backgroundColor = #colorLiteral(red: 0.9768655896, green: 0.5316846371, blue: 0.5128982067, alpha: 1)
                endingErrorLabel.isHidden = false
                if indexCode == 1 {
                    endingErrorLabel.text = StringForLocal.cannotBeANegativeNumber
                }else if indexCode == 2{
                    endingErrorLabel.text = StringForLocal.theNumberIsTooBig
                }else if indexCode == 0 {
                    endingErrorLabel.text = StringForLocal.mustBeADecimalNumber
                }
            }else {
                endingValueTextfield.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                endingErrorLabel.isHidden = true
                isEndingOk = true
            }
        }
        
        if textField == noOfPeriodsTextfield {
            let indexCode = Tools.textIntValid(inputText: textField.text!)
            if indexCode != -1 && indexCode != -2 {
                isPeriodOk = false
                noOfPeriodsTextfield.backgroundColor = #colorLiteral(red: 0.9768655896, green: 0.5316846371, blue: 0.5128982067, alpha: 1)
                periodErrorLabel.isHidden = false
                if indexCode == 1 {
                    periodErrorLabel.text = StringForLocal.cannotBeANegativeNumber
                }else if indexCode == 2{
                    periodErrorLabel.text = StringForLocal.theNumberIsTooBig
                }else if indexCode == 0 {
                    periodErrorLabel.text = StringForLocal.mustBeAnInteger
                }
            }else {
                noOfPeriodsTextfield.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                periodErrorLabel.isHidden = true
                isPeriodOk = true
            }
        }        
    }
    
    @objc func startingValueTextFieldDidChange(_ textField: UITextField) {
        startingValueTextfield.text = Tools.fixCurrencyTextInTextfield(moneyStr: startingValueTextfield.text ?? "" )
    }
    
    @objc func endingValueTextfieldDidChange(_ textField: UITextField) {
        endingValueTextfield.text = Tools.fixCurrencyTextInTextfield(moneyStr: endingValueTextfield.text ?? "" )
    }
    
    @objc func noOfPeriodsTextfieldDidChange(_ textField: UITextField) {
        noOfPeriodsTextfield.text = Tools.fixCurrencyTextInTextfield(moneyStr: noOfPeriodsTextfield.text ?? "" )
    }
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        startingValueTextfield.resignFirstResponder()
        endingValueTextfield.resignFirstResponder()
        noOfPeriodsTextfield.resignFirstResponder()
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        if startingValueTextfield.text == "" {
            startingValueTextfield.text = "1"
            isStartingOk = true
        }
        if endingValueTextfield.text == "" {
            endingValueTextfield.text = "1"
            isEndingOk = true
        }
        if noOfPeriodsTextfield.text == "" {
            noOfPeriodsTextfield.text = "1"
            isPeriodOk = true
        }
        self.view.endEditing(true)
        
        if isStartingOk && isEndingOk && isPeriodOk {
            //Get textfield text without space
            let startText = startingValueTextfield.text?.stringByRemovingWhitespaces
            let endText = endingValueTextfield.text?.stringByRemovingWhitespaces
            let periodText = noOfPeriodsTextfield.text?.stringByRemovingWhitespaces
            
            //Change value to integer, decimal
            let startDouble = Double(startText!.replacingOccurrences(of: ",", with: ""))
            let endDouble = Double(endText!.replacingOccurrences(of: ",", with: ""))
            let periodDouble = Double(periodText!.replacingOccurrences(of: ",", with: ""))
            
            //MARK: - Calculate block
            if startDouble != 0 && endDouble != 0 && periodDouble != 0 {
                let powerTop = 1/periodDouble!
                var result = pow(endDouble!/startDouble!, powerTop) - 1
                exactlyResult = result
                result = result * 100
                
                result = round(result * 100) / 100
                resultLabel.text = "\(result)%"
                
                growthTableButton.isEnabled = true
                if UIDevice.current.userInterfaceIdiom == .phone {
                    let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
                    scrollView.setContentOffset(bottomOffset, animated: true)
                }
                
                periodToGrowthAndChart = Int(periodDouble!)
                startToGrowthAndChart = startDouble!
                endToGrowthAndChart = endDouble!
                
                calculateGrowthTable()
                if endToGrowthAndChart < startToGrowthAndChart {
                    setupPieChart(investmentValue: 1, returnValue: 0)
                }else {
                    setupPieChart(investmentValue: startToGrowthAndChart, returnValue: endToGrowthAndChart - startToGrowthAndChart)
                }
                
                growthTableButton.isEnabled = true
                
            }else {
                AlertService.showInfoAlert(in: self, title: "Error", message: StringForLocal.theValueEnteredMustBeGreaterThan0)
                return
            }
           
        }else {
            AlertService.showInfoAlert(in: self, title: "Issue", message: StringForLocal.thereWere1OrMoreInputErrors)
        }
              
    }
    
    @IBAction func scrollUpButtonPressed(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func showGrowthTableButtonPressed(_ sender: UIButton) {
        //Reset value to when calculate button pressed
    }
    
    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        startingValueTextfield.text = ""
        startingValueTextfield.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        startingErrorLabel.isHidden = true
        isStartingOk = true
        
        endingValueTextfield.text = ""
        endingValueTextfield.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        endingErrorLabel.isHidden = true
        isEndingOk = true
        
        noOfPeriodsTextfield.text = ""
        noOfPeriodsTextfield.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        periodErrorLabel.isHidden = true
        isPeriodOk = true
        
        growthTableButton.isEnabled = false
        
        resultLabel.text = "0.0%"
    }
    
    func calculateGrowthTable(){
        years = []
        let yearFirst = Year(nOY: 0, v: round(startToGrowthAndChart * 100) / 100)
        years.append(yearFirst)

        var yearResult = startToGrowthAndChart
        for i in 1..<periodToGrowthAndChart {
            yearResult = yearResult + yearResult * exactlyResult
            let year = Year(nOY: i, v: round(yearResult * 100) / 100 )
            years.append(year)
            
        }
        let yearLast = Year(nOY: periodToGrowthAndChart, v: round(endToGrowthAndChart * 100) / 100)
        years.append(yearLast)
        
        for i in years {
            print(i.value)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "growthTable",
            let destinationVC = segue.destination as? GrowthTableController {
            destinationVC.years = years
        }
    }
    

}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}


