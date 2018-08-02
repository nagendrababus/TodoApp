//
//  Item.swift
//  TodoApp
//
//  Created by Nagendra Babu on 01/08/18.
//  Copyright © 2018 Nagendra Babu. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
  @objc dynamic var title:String = ""
  @objc dynamic var done:Bool = false
  @objc dynamic var dateCreated:Date?
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
