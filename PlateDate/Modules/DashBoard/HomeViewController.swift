//
//  HomeViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 03/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import PageMenu

class HomeViewController: UIViewController, UISearchControllerDelegate {

    // Mark: - @IBOutlets
    @IBOutlet var topView: UIView!
    @IBOutlet var recipeSearchTextField: SearchTextField!
    @IBOutlet var trendingTableView: UITableView!
    @IBOutlet var followingTableView: UITableView!
    @IBOutlet var segmentTitle: ScrollableSegmentedControl!
    @IBOutlet var trendingTableViewLeading: NSLayoutConstraint!
    @IBOutlet var trendingTableViewTrailing: NSLayoutConstraint!
    @IBOutlet var followingTableViewLeading: NSLayoutConstraint!
    @IBOutlet var followingTableViewTrailing: NSLayoutConstraint!

    // Mark: - Declaration
    let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trendingReuseIdentifier()
        followingReuseIdentifier()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        recipeSearchTextField.clipsToBounds = true
        setUpSegment()
    }

    // Mark: - SetUp Segment
    func setUpSegment() {
        segmentTitle.segmentStyle = .textOnly
        segmentTitle.insertSegment(withTitle: "Trending", image: nil, at: 0)
        segmentTitle.insertSegment(withTitle: "Following", image: nil, at: 1)
        segmentTitle.underlineSelected = true
        segmentTitle.selectedSegmentIndex = 0
        segmentTitle.fixedSegmentWidth = true
        segmentTitle.tintColor = UIColor._lightningYellow

        followingTableViewLeading.constant = screenSize.width
        followingTableViewTrailing.constant = -screenSize.width
        segmentTitle.addTarget(self, action: #selector(HomeViewController.segmentSelected(sender:)), for: .valueChanged)
    }

     // Mark: - Segment Selected
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        if sender.selectedSegmentIndex == 0 {
             UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.trendingTableViewLeading.constant = 0
                self.trendingTableViewTrailing.constant = 0
                self.followingTableViewLeading.constant = self.screenSize.width
                self.followingTableViewTrailing.constant = -self.screenSize.width
                self.view.layoutIfNeeded()
            })
        } else {
             UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.followingTableViewLeading.constant = 0
                self.followingTableViewTrailing.constant = 0
                self.trendingTableViewLeading.constant = -self.screenSize.width
                self.trendingTableViewTrailing.constant = self.screenSize.width
                self.view.layoutIfNeeded()
             })
        }
    }

    // Mark: - Trending
    func trendingReuseIdentifier() {
        trendingTableView.delegate = self
        trendingTableView.register(UINib(nibName: TableViewCell.ClassName.trending, bundle: nil), forCellReuseIdentifier: TableViewCell.ReuseIdentifier.trending)
        trendingTableView.separatorStyle = .none
        trendingTableView.reloadData()
        trendingTableView.backgroundColor = .clear
    }

    // Mark: - Following
    func followingReuseIdentifier() {
        followingTableView.delegate = self
        followingTableView.register(UINib(nibName: TableViewCell.ClassName.following, bundle: nil), forCellReuseIdentifier: TableViewCell.ReuseIdentifier.following)
        followingTableView.separatorStyle = .none
        followingTableView.reloadData()
        followingTableView.backgroundColor = .clear
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar()
    }

    func segmentButton() {
        trendingTableView.frame = CGRect(x:0, y:trendingTableView.frame.origin.y, width:trendingTableView.frame.width, height:trendingTableView.frame.height)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    //MARK: - TableView data source
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewHeight(tableView:trendingTableView, height: 680.0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == trendingTableView {
            let cell = trendingTableView.dequeueReusableCell(withIdentifier:  TableViewCell.ReuseIdentifier.trending) as! TrendingRecipiesTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
        return cell
        }
        else {
            let cell = followingTableView.dequeueReusableCell(withIdentifier:  TableViewCell.ReuseIdentifier.following) as! FollowingRecipiesTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        }
    }
}
