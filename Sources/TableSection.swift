import UIKit

class TableSection {
    
    var rows: [TableRow] = []
    
    func numberOfVisibleRows() -> Int {
        return rows.filter { !$0.hiding }.count
    }
    
}
