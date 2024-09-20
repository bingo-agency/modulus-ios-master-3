//
//  KYCModels.swift
//  Modulus
//
//  Created by Bhavesh Sarwar on 20/05/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import Foundation


//struct KYCField: Decodable{
//
//    let fieldName: String
//    let fieldTitle: String
//    let dataType: String
//    let episodeId: [String]
//
//
//    enum CodingKeys: String, CodingKey {
//
//        case name = "Name"
//        case episodeId = "episode_ids"
//    }
//
//
//}
class KYCField:Decodable{

    let fieldName: String?
    let fieldTitle: String?
    let dataType: String?
    let masterMandatory: Bool?
    let mandatory: Bool?
    let inputType: String?
    let options: [String:String?]?
    let description: String?
    let errorMessage: String?
    let fieldsList:[KYCField]?
    var value:String?
    let isCorporate: Bool?
    let isIgnored: Bool?
    let level : Int

    enum CodingKeys: String, CodingKey {

        case fieldName = "fieldName"
        case fieldTitle = "fieldTitle"
        case dataType = "dataType"
        case masterMandatory = "masterMandatory"
        case mandatory = "mandatory"
        case inputType = "inputType"
        case options = "options"
        
        case description = "description"
        case errorMessage = "errorMessage"
        case fieldsList = "fieldsList"
        case value = "value"
        case isCorporate = "isCorporate"
        case isIgnored = "isIgnored"
        case level = "level"
    }
    
    enum inputTypes:String{
        case TextBox = "TextBox"
        case Date = "Date"
        case DropDown = "DropDown"
        case File = "File"
        case Panel = "Panel"
        case RadioButton = "RadioButton"
//        case date = "Date"
    }

}

class kycFieldView:UIView{
    var field:KYCField?
    var parentField:KYCField?
}
