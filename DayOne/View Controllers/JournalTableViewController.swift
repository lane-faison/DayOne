//
//  JournalTableViewController.swift
//  DayOne
//
//  Created by Lane Faison on 7/1/18.
//  Copyright © 2018 Lane Faison. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
}

extension JournalTableViewController {
    private func setupButtons() {
        cameraButton.imageView?.contentMode = .scaleAspectFit
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cameraButtonTapped() {
        performSegue(withIdentifier: "goToNew", sender: "camera")
    }
    
    @objc private func addButtonTapped() {
        performSegue(withIdentifier: "goToNew", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
    }
}
