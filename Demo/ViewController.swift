import UIKit
import StaticTableViewController

class ViewController: StaticTableViewController {

    @IBOutlet weak var showAllCell: UITableViewCell!
    @IBOutlet weak var hideMeCell1: UITableViewCell!
    @IBOutlet weak var hideMeCell2: UITableViewCell!
    @IBOutlet weak var hideMeCell3: UITableViewCell!
    @IBOutlet weak var hideMeCell4: UITableViewCell!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == IndexPath(row: 0, section: 0) {
            set(cells: showAllCell, hideMeCell1, hideMeCell2, hideMeCell3, hideMeCell4, hidden: false)
        } else {
            let cell = tableView.cellForRow(at: indexPath)
            set(cells: cell!, hidden: true)
        }
        
        reloadData(animated: true)
    }

}
