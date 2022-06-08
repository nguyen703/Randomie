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

//MARK: - TableView Delegate Methods
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // TODO: Config sections UI
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.contentView.backgroundColor = .clear
            headerTitle.textLabel?.textColor = K.Palette.activeTextColor
            headerTitle.textLabel?.font = UIFont.italicSystemFont(ofSize: K.TableView.sectionFontSize)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return K.TableView.sectionHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return SettingsData.sectionsTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SettingsData.settings[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return SettingsData.sectionsTitle[section]
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = SettingsData.settings[indexPath.section][indexPath.row]
        content.textProperties.color = K.Palette.activeTextColor
        content.image = UIImage(named: K.Icon.settingsScreen)
        content.imageProperties.tintColor = K.Palette.activeTextColor
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
