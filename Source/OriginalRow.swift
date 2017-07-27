import UIKit

enum BatchOperation {
    case none, insert, delete, update
}

class OriginalRow {
    
    init(cell: UITableViewCell, originalIndexPath: IndexPath){
        self.cell = cell
        self.originalIndexPath = originalIndexPath
    }

    var hidden: Bool {
        get {
            return hiddenPlanned
        }
        set {
            if !hiddenReal && newValue {
                batchOperation = .delete
            } else if hiddenReal && !newValue {
                batchOperation = .insert
            }
            
            hiddenPlanned = newValue
        }
    }
    
    var hiddenReal: Bool = false

    var hiddenPlanned: Bool = false
    
    var batchOperation: BatchOperation = .none
    
    var cell: UITableViewCell
    
    var originalIndexPath: IndexPath
    
    var height: CGFloat = CGFloat.greatestFiniteMagnitude
    
    func update() {
        if !hidden && batchOperation == .none {
            batchOperation = .update
        }
    }
    
}
