import CoreData
import UIKit

class CoreDataHandler {
    static let shared = CoreDataHandler()
    private init() {}

    func saveInspection(id: String, state: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CDInspection", in: context)!
        let inspection = NSManagedObject(entity: entity, insertInto: context)
        
        inspection.setValue(id, forKey: "id")
        inspection.setValue(state, forKey: "state")
        
        do {
            try context.save()
        } catch {
            print("Failed to save inspection: \(error)")
        }
    }

    func fetchInspections() -> [NSManagedObject]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDInspection")
        
        do {
            let inspections = try context.fetch(fetchRequest)
            return inspections
        } catch {
            print("Failed to fetch inspections: \(error)")
            return nil
        }
    }
    
    func updateInspection(id: String, state: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDInspection")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let result = try context.fetch(fetchRequest)
            if let inspectionToUpdate = result.first as? NSManagedObject {
                inspectionToUpdate.setValue(state, forKey: "state")
                try context.save()
            }
        } catch {
            print("Failed to update inspection: \(error)")
        }
    }
}



