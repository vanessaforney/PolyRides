//
//  Location.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/19/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import GoogleMaps

class Location {

  var place: GMSPlace?
  var city: String?

  init(placeId: String, city: String) {
    self.city = city
    GoogleMapsHelper.placesClient.lookUpPlaceID(placeId) { [weak self] place, error in
      if error == nil {
        self?.place = place
      }
    }
  }

}
