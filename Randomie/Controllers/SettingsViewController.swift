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
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: K.TableView.identifierSettings)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.backgroundColor = .clear

        // Do not allow screen rotation
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.identifierSettings, for: indexPath)
        cell.configCellColor(cellTitle: SettingsData.settings[indexPath.section][indexPath.row],
                             cellImage: UIImage(named: K.Icon.settingsScreen)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        // TODO: Config cell properties right before highlight (start touching)
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.configCellColor(cellTitle: SettingsData.settings[indexPath.section][indexPath.row],
                                 cellImage: UIImage(named: K.Icon.settingsScreen)!,
                                 textColor: .white)
        }

    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        // TODO: Config cell properties after unhighlight (release touching)
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.configCellColor(cellTitle: SettingsData.settings[indexPath.section][indexPath.row],
                                 cellImage: UIImage(named: K.Icon.settingsScreen)!)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        settingsTableView.deselectRow(at: indexPath, animated: true)
        
        //TODO: navigate to the corresponding screen
        let section = indexPath.section
        let row = indexPath.row
        
        switch SettingsData.settings[section][row] {
        case "Change sticker":
            performSegue(withIdentifier: K.TableView.segueChangeEmoji, sender: self)
        case "About us":
            performSegue(withIdentifier: K.TableView.segueAboutUs, sender: self)
        default: break
        }
        
    }
    
}
