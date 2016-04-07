//
//  SearchTableViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 3/14/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

import CoreLocation
import BubbleTransition

class RegionTableViewCell: UITableViewCell {

  @IBOutlet weak var backgroundImageView: UIImageView?
  @IBOutlet weak var locationBackgroundView: UIView?
  @IBOutlet weak var location: UILabel?
  @IBOutlet weak var numRides: UILabel?

  var toRides: [Ride]?
  var fromRides: [Ride]?
  var region: Region?

  override func setHighlighted(highlighted: Bool, animated: Bool) {
    if highlighted {
      backgroundImageView?.alpha = 0.5
      locationBackgroundView?.alpha = 0.5
      location?.textColor = Color.Gray
      numRides?.textColor = Color.Gray
    } else {
      backgroundImageView?.alpha = 1.0
      locationBackgroundView?.alpha = 0.65
      location?.textColor = Color.White
      numRides?.textColor = Color.White
    }
  }

}

class RegionTableViewController: TableViewController {

  @IBOutlet weak var searchButton: UIButton?

  let transition = BubbleTransition()

  var user: User?
  var allRides: [Ride]?
  var toRegionToRides: [Region: [Ride]]?
  var fromRegionToRides: [Region: [Ride]]?

  override func viewDidLoad() {
    super.viewDidLoad()

    if let tabBarController = tabBarController as? TabBarController {
      user = tabBarController.user
    }

    tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
    tableView?.dataSource = self

    if let searchButton = searchButton {
      searchButton.clipsToBounds = true
      searchButton.layer.cornerRadius = searchButton.layer.frame.size.width / 2
    }
    setupAppearance()
  }

  override func viewWillAppear(animated: Bool) {
    navigationController?.setNavigationBarHidden(true, animated: true)
    super.viewWillAppear(animated)
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
    } else if segue.identifier == "toSearch" {
      if let vc = segue.destinationViewController as? SearchViewController {
        vc.allRides = allRides
        vc.user = user
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .Custom
      }
    }

    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem
  }

}

// MARK: - UITableViewDataSource
extension RegionTableViewController: UITableViewDataSource {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Region.allRegions.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let region = Region.allRegions[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier("RegionCell", forIndexPath: indexPath)

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
    }

    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

}


// MARK: - UIViewControllerTransitioningDelegate
extension RegionTableViewController: UIViewControllerTransitioningDelegate {

  func animationControllerForPresentedController(presented: UIViewController,
                                                 presentingController presenting: UIViewController,
                                                 sourceController source: UIViewController)
                                                 -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .Present
    if let searchButton = searchButton {
      transition.startingPoint = searchButton.center
    }
    transition.bubbleColor = Color.Blue
    return transition
  }

  func animationControllerForDismissedController(dismissed: UIViewController)
                                                 -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .Dismiss
      if let searchButton = searchButton {
        transition.startingPoint = searchButton.center
      }
    transition.bubbleColor = Color.Blue
    return transition
  }

}
