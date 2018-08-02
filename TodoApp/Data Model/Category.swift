//
//  Category.swift
//  TodoApp
//
//  Created by Nagendra Babu on 01/08/18.
//  Copyright © 2018 Nagendra Babu. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object{
    @objc dynamic var name:String = ""
    let items = List<Item>()
}
