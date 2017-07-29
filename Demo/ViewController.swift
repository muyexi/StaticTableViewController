import UIKit
import StaticTableViewController

class ViewController: StaticTableViewController {

    @IBOutlet weak var showAllCell: UITableViewCell!
    @IBOutlet weak var hideMeCell1: UITableViewCell!
    @IBOutlet weak var hideMeCell2: UITableViewCell!
    @IBOutlet weak var hideMeCell3: UITableViewCell!
    @IBOutlet weak var hideMeCell4: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                set(cells: showAllCell, hideMeCell1, hideMeCell2, hideMeCell3, hideMeCell4, hidden: false)
            default:
                break
            }
        } else if indexPath.section >= 1 {
            let cell = tableView.cellForRow(at: indexPath)
            set(cells: cell!, hidden: true)
        }
        
        reloadData(animated: true)
    }

}
