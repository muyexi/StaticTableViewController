//
//  ViewController.swift
//  Demo
//
//  Created by muyexi on 8/31/16.
//  Copyright © 2016 muyexi. All rights reserved.
//

import UIKit
import StaticTableViewController

class ViewController: StaticTableViewController {

    @IBOutlet weak var showAllCell: UITableViewCell!
    @IBOutlet weak var hideMeCell1: UITableViewCell!
    @IBOutlet weak var hideMeCell2: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cells([showAllCell, hideMeCell1, hideMeCell2], hidden: false)
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cells([hideMeCell1], hidden: true)
            default:
                break
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                cells([hideMeCell2], hidden: true)
            default:
                break
            }
        }
        
        reloadDataAnimated(true)
    }

}
