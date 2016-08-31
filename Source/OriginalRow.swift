import UIKit

enum BatchOperation {
    case None, Insert, Delete, Update
}

class OriginalRow {
    
    convenience init(cell: UITableViewCell, originalIndexPath: NSIndexPath){
        self.init()
        
        self.cell = cell
        self.originalIndexPath = originalIndexPath
    }

    var hidden: Bool {
        get {
            return hiddenPlanned
        }
        set {
            if !hiddenReal && newValue {
                batchOperation = .Delete
            } else if hiddenReal && !newValue {
                batchOperation = .Insert
            }
            
            hiddenPlanned = newValue
        }
    }
    
    var hiddenReal: Bool = false

    var hiddenPlanned: Bool = false
    
    var batchOperation: BatchOperation = .None
    
    var cell: UITableViewCell?
    
    var originalIndexPath: NSIndexPath?
    
    var height: CGFloat = CGFloat.max
    
    func update() {
        if !hidden && batchOperation == .None {
            batchOperation = .Update
        }
    }
    
}
