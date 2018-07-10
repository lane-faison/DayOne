//
//  JournalTableViewController.swift
//  DayOne
//
//  Created by Lane Faison on 7/1/18.
//  Copyright © 2018 Lane Faison. All rights reserved.
//

import UIKit
import RealmSwift

class JournalTableViewController: UITableViewController {
    
    @IBOutlet weak var topButtonContainer: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var entries: Results<Entry>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getEntries()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let entries = entries {
            return entries.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as? JournalCell {
            if let entry = entries?[indexPath.row] {
                cell.previewTextLabel.text = entry.text
                if let image = entry.pictures.first?.thumbnailImage() {
                    cell.previewImageWidth.constant = 100
                    cell.previewImageView.image = image
                } else {
                    cell.previewImageWidth.constant = 0
                }
                
                cell.dayLabel.text = entry.formattedDayString()
                cell.monthLabel.text = entry.formattedMonthString()
                cell.yearLabel.text = entry.formattedYearString()
            }
            return cell
        }

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    private func getEntries() {
        if let realm = try? Realm() {
            entries = realm.objects(Entry.self).sorted(byKeyPath: "date", ascending: false)
            tableView.reloadData()
        }
    }
}

extension JournalTableViewController {
    
    private func setupView() {
        navigationController?.navigationBar.barTintColor = blueTheme
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        topButtonContainer.backgroundColor = blueTheme
    }
    
    private func setupButtons() {
        cameraButton.imageView?.contentMode = .scaleAspectFit
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cameraButtonTapped() {
        performSegue(withIdentifier: "goToNew", sender: "camera")
    }
    
    @objc private func addButtonTapped() {
        performSegue(withIdentifier: "goToNew", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNew" {
            if let text = sender as? String {
                if text == "camera" {
                    let createVC = segue.destination as? CreateJournalViewController
                    createVC?.startWithCamera = true
                }
            }
        }
    }
}
