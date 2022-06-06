//
//  SettingsViewController.swift
//  Randomie
//
//  Created by Nguyen NGO on 01/06/2022.
//

import UIKit
import ChameleonFramework

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    let sectionsTitle = ["Visualization",
                          "General",
                          "Review"]
    let settings = [["Change sticker"],
                    ["About me", "Privacy & Data"],
                    ["Review App"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.backgroundColor = .clear

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { return }
        
        navBar.tintColor = K.Palette.activeTextColor
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: K.Palette.activeTextColor]
        
        navigationItem.largeTitleDisplayMode = .always
        navBar.prefersLargeTitles = true
        navBar.sizeToFit()
    }
    
    func setup() {
        let gradientColor = GradientColor(.topToBottom, frame: UIScreen.main.bounds, colors: Array(arrayLiteral: K.Palette.firstColor, K.Palette.secondColor, K.Palette.thirdColor))

        view.backgroundColor = gradientColor
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // TODO: Config sections UI
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionsTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settings[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionsTitle[section]
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        
        var content = cell.defaultContentConfiguration()
        
        content.text = settings[indexPath.section][indexPath.row]
        content.textProperties.color = K.Palette.activeTextColor
        cell.backgroundColor = .clear
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        // TODO: Config cell properties right before highlight (start touching)

    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        // TODO: Config cell properties after unhighlight (release touching)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        settingsTableView.deselectRow(at: indexPath, animated: true)
    }
    
}
