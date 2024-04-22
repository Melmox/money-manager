//
//  DBStorableObject.swift
//  money-manager
//
//  Created by developer on 15.04.2024.
//

import CoreData

public protocol DBStorableObject: NSManagedObject {
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    static var primaryKey: String { get }
    static var _entityName: String { get }
}

public extension DBStorableObject {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: primaryKey, ascending: true)]
    }
    
    static var primaryKey: String {
        return Self.primaryKey
    }
    
    static var _entityName: String {
        
        let entityName: String? = {
            
            if #available(iOS 10.0, *) {
                return entity().name
            } else {
                return nil
            }
        }()
        
        if let entityName: String = entityName {
            return entityName
        } else {
            assert(false, "Override this method in subclasses before iOS 10!")
            return ""
        }
    }
    
    static func allObjects(in context: NSManagedObjectContext) -> [Self] {
        
        var array: [Self] = []
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
        fetchRequest.sortDescriptors = defaultSortDescriptors
        
        do {
            let fetchedEntities: [Self] = try context.fetch(fetchRequest) as? [Self] ?? []
            array = fetchedEntities
        } catch {
            print(error)
        }
        
        return array
    }
    
    static func objectsWith(offset: Int, limit: Int, predicate: NSPredicate? = nil, in context: NSManagedObjectContext) -> [Self] {
        
        var array: [Self] = []
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)

        fetchRequest.predicate = predicate
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit
        fetchRequest.sortDescriptors = defaultSortDescriptors
        
        do {
            let fetchedEntities: [Self] = try context.fetch(fetchRequest) as? [Self] ?? []
            array = fetchedEntities
        } catch {
            print(error)
        }

        return array
    }
    
    static func makeObject(in context: NSManagedObjectContext) -> Self? {
        
        var result: Self?
        
        if let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: _entityName, in: context) {
            result = (self as NSManagedObject.Type).init(entity: entity, insertInto: context) as? Self
        }
        
        return result
    }
}
