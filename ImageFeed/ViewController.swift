//
//  ViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 09.01.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    let cellIdentifier = "cell"
    let words = ["Apple", "Pear", "Watermelon", "Carrot", "Pickle", "Potato", "Tomato"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - <UITableViewDataSource>

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        cell.textLabel?.text = words[indexPath.row]
        
        return cell
    }
}
