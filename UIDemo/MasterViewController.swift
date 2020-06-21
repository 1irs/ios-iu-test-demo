//
//  MasterViewController.swift
//  UIDemo
//
//  Created by Vladimir Obrizan on 30.05.2020.
//  Copyright © 2020 Design and Test Lab. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var viewControllers : [(String, () -> UIViewController)] = [
        ("SearchVC", {
            let fakeSuggestService = FakeSuggestService(words: [
                "Apple",
                "Apricot",
                "Avocado",
                "Banana",
                "Blackberries",
                "Blackcurrant",
                "Blueberries",
                "Breadfruit"
            ])
            let searchViewController = DNTLSearchViewController()
            searchViewController.suggestionService = fakeSuggestService
            return searchViewController
        })
    ]

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = viewControllers[indexPath.row].0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcFactory = viewControllers[indexPath.row].1
        let vc = vcFactory()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

