//
//  Currency.swift
//  Modulus
//
//  Created by Bhavesh Sarwar on 27/04/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import Foundation

enum walletTypes:String{
    case ripple = "Ripple"
    case fiatManual = "Fiat-Manual"
    case fiatPG = "Fiat-PG"
    case stellar = "Stellar"
    case bitCoin = "Bitcoin"
    case ethereum = "Ethereum"
}

struct Currency{
    var shortName:String?
    var fullName :String?
    var buyServiceCharge:Double?
    var sellServiceCharge:Double?
    var withdrawalServiceCharge:Double?
    var withdrawalServiceChargeInBTC:String?
    var confirmationCount:Double?
    var contractAddress:String?
    var minWithdrawalLimit:Double?
    var maxWithdrawalLimit:Double?
    var decimalPrecision:Int?
    var currencyEnabled:Bool?
    var tradeEnabled:Bool?
    var tradeEnabled_Buy:Bool?
    var tradeEnabled_Sell:Bool?
    var depositEnabled:Bool?
    var withdrawalEnabled:Bool?
    var secondaryWalletType:String?
    var addressSeparator:String?
    var walletType:String?
    var withdrawalServiceChargeType:String?
    
    
    
    init(data:NSDictionary) {
        shortName = data.valueForCaseInsensativeKey(forKey: "shortName") as? String
        fullName = data.valueForCaseInsensativeKey(forKey: "fullName") as? String
        buyServiceCharge = data.valueForCaseInsensativeKey(forKey: "buyServiceCharge") as? Double
        sellServiceCharge = data.valueForCaseInsensativeKey(forKey: "sellServiceCharge") as? Double
        withdrawalServiceCharge = data.valueForCaseInsensativeKey(forKey: "withdrawalServiceCharge") as? Double
        confirmationCount = data.valueForCaseInsensativeKey(forKey: "confirmationCount") as? Double
        contractAddress = data.valueForCaseInsensativeKey(forKey: "contractAddress") as? String
        minWithdrawalLimit = data.valueForCaseInsensativeKey(forKey: "minWithdrawalLimit") as? Double
        maxWithdrawalLimit = data.valueForCaseInsensativeKey(forKey: "maxWithdrawalLimit") as? Double
        decimalPrecision = data.valueForCaseInsensativeKey(forKey: "decimalPrecision") as? Int
        currencyEnabled = data.valueForCaseInsensativeKey(forKey: "currencyEnabled") as? Bool
        tradeEnabled = data.valueForCaseInsensativeKey(forKey: "tradeEnabled") as? Bool
        tradeEnabled_Buy = data.valueForCaseInsensativeKey(forKey: "tradeEnabled_Buy") as? Bool
        tradeEnabled_Sell = data.valueForCaseInsensativeKey(forKey: "tradeEnabled_Sell") as? Bool
        depositEnabled = data.valueForCaseInsensativeKey(forKey: "depositEnabled") as? Bool
        withdrawalEnabled = data.valueForCaseInsensativeKey(forKey: "withdrawalEnabled") as? Bool
        secondaryWalletType = data.valueForCaseInsensativeKey(forKey: "secondaryWalletType") as? String
        addressSeparator = data.valueForCaseInsensativeKey(forKey: "addressSeparator") as? String
        walletType = data.valueForCaseInsensativeKey(forKey: "walletType") as? String
        withdrawalServiceChargeType = data.valueForCaseInsensativeKey(forKey: "withdrawalServiceChargeType") as? String
    }
    
}
