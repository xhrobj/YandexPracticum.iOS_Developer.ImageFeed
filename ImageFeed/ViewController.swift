//
//  ViewController.swift
//  ImageFeed
//
//  Created by Mikhail Eliseev on 09.01.2024.
//

import UIKit

final class ViewController: UIViewController {
    let cellIdentifier = "cell"
    
    let headers = ["Fruits", "Vegetables", "Berries"]
    let words = [
        ["Apple", "Pear", "Watermelon"],
        ["Carrot", "Pickle", "Potato", "Tomato"],
        ["Strawberry", "Raspberry", "Blackberry", "Blueberry"]
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionHeaderHeight = 32
    }
}

// MARK: - <UITableViewDataSource>

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        words.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        headers[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        words[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        cell.textLabel?.text = words[indexPath.section][indexPath.row]
        
        return cell
    }
}

// MARK: - <UITableViewDelegate>

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(
            title: nil,
            message: "Вы нажали на: \(words[indexPath.section][indexPath.row])",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
