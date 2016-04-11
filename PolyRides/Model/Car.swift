//
//  Car.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/1/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

class Car {

  var make: String?
  var model: String?
  var year: Int?
  var color: String?

  init() { }

  init(make: String?, model: String?, year: String?, color: String?) {
    self.make = make
    self.model = model
    self.color = color
    if let year = year {
      self.year = Int(year)
    }
  }

  func getDescription() -> String? {
    var descriptionComponents = [String]()

    if let make = make {
      descriptionComponents.append(make)
    }
    if let model = model {
      descriptionComponents.append(model)
    }
    if let year = year {
      descriptionComponents.append("(\(year))")
    }
    if let color = color {
      descriptionComponents.insert(color, atIndex: 0)
    }

    return descriptionComponents.isEmpty ? nil : descriptionComponents.joinWithSeparator(" ")
  }

  func toAnyObject() -> [String : AnyObject] {
    var dictionary = [String : AnyObject]()

    dictionary["make"] = make
    dictionary["model"] = model
    dictionary["year"] = year
    dictionary["color"] = color

    return dictionary

  }

}