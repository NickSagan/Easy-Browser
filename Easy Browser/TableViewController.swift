//
//  TableViewController.swift
//  Easy Browser
//
//  Created by Nick Sagan on 24.10.2021.
//

import UIKit

class TableViewController: UITableViewController {
    
    // Safe list of web sites
    var websites = ["disney.ru", "kiddle.co", "factmonster.com", "apple.com", "youtubekids.com"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Easy Browser"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "websiteCell", for: indexPath)

        cell.textLabel?.text = websites[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let browser = storyboard?.instantiateViewController(withIdentifier: "browser") as? ViewController {
            browser.selectedSite = websites[indexPath.row]
            navigationController?.pushViewController(browser, animated: true)
            browser.websites = websites
        }
    }


}
