//
//  SearchTableViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/14/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import CoreLocation

class RegionTableViewCell: UITableViewCell {

  @IBOutlet weak var backgroundImageView: UIImageView?
  @IBOutlet weak var locationBackgroundView: UIView?
  @IBOutlet weak var location: UILabel?
  @IBOutlet weak var numRides: UILabel?

  var toRides: [Ride]?
  var fromRides: [Ride]?
  var region: Region?
  var disclosure: UITableViewCell?

  override func setHighlighted(highlighted: Bool, animated: Bool) {
    if highlighted {
      backgroundImageView?.alpha = 0.5
      locationBackgroundView?.alpha = 0.5
      disclosure?.alpha = 0.5
      location?.textColor = Color.Gray
      numRides?.textColor = Color.Gray
    } else {
      backgroundImageView?.alpha = 1.0
      locationBackgroundView?.alpha = 0.65
      disclosure?.alpha = 0.8
      location?.textColor = Color.White
      numRides?.textColor = Color.White
    }
  }

}

class RegionTableViewController: UITableViewController {

  var user: User?
  var allRides: [Ride]?
  var toRegionToRides: [Region: [Ride]]?
  var fromRegionToRides: [Region: [Ride]]?

  override func viewDidLoad() {
    super.viewDidLoad()

    if let tabBarController = tabBarController as? TabBarController {
      user = tabBarController.user
    }

    let searchBar = UISearchBar()
    searchBar.sizeToFit()
    searchBar.barStyle = .BlackTranslucent
    searchBar.delegate = self
    navigationItem.titleView = searchBar

    tableView.separatorStyle = UITableViewCellSeparatorStyle.None

    setupAppearance()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toRegionRides" {
      if let vc = segue.destinationViewController as? RegionRidesViewController {
        if let cell = sender as? RegionTableViewCell {
          vc.user = user
          vc.toRides = cell.toRides
          vc.fromRides = cell.fromRides
          vc.region = cell.region
        }
      }
    } else if segue.identifier == "toRideSearch" {
      if let vc = segue.destinationViewController as? SearchViewController {
        vc.allRides = allRides
      }
    }

    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem
  }

}

// MARK: - UITableViewDataSource
extension RegionTableViewController {

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Region.allRegions.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let region = Region.allRegions[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier("regionCell", forIndexPath: indexPath)

    if let regionCell = cell as? RegionTableViewCell {
      regionCell.region = region
      regionCell.backgroundImageView?.image = region.image()
      regionCell.location?.text = region.name()
      var count = 0
      if let toRides = toRegionToRides?[region] {
        regionCell.toRides = toRides
        count += toRides.count
      }
      if let fromRides = fromRegionToRides?[region] {
        regionCell.fromRides = fromRides
        count += fromRides.count
      }
      regionCell.numRides?.text = "\(count) rides"

      let disclosure = UITableViewCell()
      disclosure.accessoryType = .DisclosureIndicator
      disclosure.frame = cell.bounds
      disclosure.userInteractionEnabled = false
      regionCell.addSubview(disclosure)
      regionCell.disclosure = disclosure
    }

    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

}

// MARK: - UISearchBarDelegate
extension RegionTableViewController: UISearchBarDelegate {

  func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    performSegueWithIdentifier("toRideSearch", sender: self)
    return false
  }

}
