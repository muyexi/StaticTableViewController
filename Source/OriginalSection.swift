import UIKit

class OriginalSection {
    
    var rows: [OriginalRow] = []
    
    func numberOfVissibleRows() -> Int {
        return rows.filter { !$0.hiding }.count
    }
    
}
