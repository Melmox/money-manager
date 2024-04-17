//
//  DBStorage.swift
//  money-manager
//
//  Created by developer on 15.04.2024.
//

import CoreData

extension NSManagedObject {
    
    func inContext(_ aContext: NSManagedObjectContext) -> Self? {
        return inContext(aContext, type: type(of: self))
    }
    
    private func inContext<T>(_ aContext: NSManagedObjectContext, type: T.Type) -> T? {
        var result: T?
        
        do {
            try managedObjectContext?.obtainPermanentIDs(for: [self])
            aContext.performAndWait {
                result = aContext.object(with: objectID) as? T
            }
        } catch {
            print(error)
        }
        
        return result
    }
}

protocol IDBStorage {
    var defaultContext: NSManagedObjectContext { get }

    func defaultContext(block aBlock: @escaping (NSManagedObjectContext) -> Void)
    func defaultContextAndWait(block aBlock: @escaping (NSManagedObjectContext) -> Void)
    func save(block aBlock: @escaping (NSManagedObjectContext) -> Void, completion aCompletion: (() -> Void)?)
    func saveAndWait(block aBlock: (NSManagedObjectContext) -> Void, completion aCompletion: (() -> Void)?)
    func removeAllEntitiesWithName(_ anEntityName: String, completion: (() -> Void)?)
    func remove(object aObject: NSManagedObject, completion: (() -> Void)?)
    func remove(objects aObjects: [NSManagedObject], completion: (() -> Void)?)
}

class DBStorage: IDBStorage {
    
    static let shared: DBStorage = DBStorage()
    
    var shouldCacheStorage: Bool = false
    
    private var _defaultContext: NSManagedObjectContext?
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var _managedObjectModel: NSManagedObjectModel?
    
    private let persistentStoreName: String
    
    var defaultContext: NSManagedObjectContext {
        
        if let defaultContext: NSManagedObjectContext = _defaultContext {
            
            return defaultContext
        } else {
            
            let defaultContext: NSManagedObjectContext = createDefaultContext(coordinator: persistentStoreCoordinator)
            _defaultContext = defaultContext
            return defaultContext
        }
    }

    private var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        
        if let persistentStoreCoordinator: NSPersistentStoreCoordinator = _persistentStoreCoordinator {
            
            return persistentStoreCoordinator
        } else {
            
            let persistentStoreCoordinator: NSPersistentStoreCoordinator = createPersistentStoreCoordinator(managedObjectModel)
            _persistentStoreCoordinator = persistentStoreCoordinator
            
            return persistentStoreCoordinator
        }
    }

    private var managedObjectModel: NSManagedObjectModel {
        
        if let managedObjectModel: NSManagedObjectModel = _managedObjectModel {
            
            return managedObjectModel
        } else {
            
            let managedObjectModel: NSManagedObjectModel = createManagedObjectModel()
            _managedObjectModel = managedObjectModel
            
            return managedObjectModel
        }
    }
    
    // MARK: - Initialization
    
    private init() {
        
        self.persistentStoreName = "money_manager"
        _ = defaultContext
    }

    
    // MARK: - Private
    
    private func createDefaultContext(coordinator aCoordinator: NSPersistentStoreCoordinator) -> NSManagedObjectContext {
        
        let result: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        result.persistentStoreCoordinator = aCoordinator
        result.mergePolicy = NSOverwriteMergePolicy
        result.undoManager = nil
        
        return result
    }
    
    private func createPersistentStoreCoordinator(_ objectModel: NSManagedObjectModel) -> NSPersistentStoreCoordinator {
        
        let fileManager: FileManager = FileManager.default
        
        guard let directoryURL: URL = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last else {
            assert(true, #function + " persistentStoreName " + String(describing: self))
            return NSPersistentStoreCoordinator()
        }
        
        var storeUrl: URL = NSURL.fileURL(withPath: persistentStoreName, relativeTo: directoryURL)
        
        storeUrl.setTemporaryResourceValue(self.shouldCacheStorage, forKey: URLResourceKey.isExcludedFromBackupKey)
        
        let result: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try result.addPersistentStore(ofType: self.storeType(), configurationName: nil, at: storeUrl, options: self.migrationPolicy())
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    private func createManagedObjectModel() -> NSManagedObjectModel {
        
        var result: NSManagedObjectModel
        
        if self.mergeModels() {
            
            if let mergedModel: NSManagedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main]) {
                
                result = mergedModel
            } else {
                
                assert(true, #function + String(describing: self))
                result = NSManagedObjectModel()
            }
        } else {
            
            let name: String = self.persistentStoreName.replacingOccurrences(of: ".sqlite", with: "")
            
            if let modelPath: String = Bundle.main.path(forResource: name, ofType: "momd") {
                
                let modelURL: URL = URL(fileURLWithPath: modelPath)
                
                if let managedObjectModel: NSManagedObjectModel = NSManagedObjectModel(contentsOf: modelURL) {
                    
                    result = managedObjectModel
                } else {
                    
                    assert(true, #function + String(describing: self))
                    result = NSManagedObjectModel()
                }
            } else {
                
                assert(true, #function + String(describing: self))
                result = NSManagedObjectModel()
            }
        }
        
        return result
    }
    
    private func storeType() -> String {
        
        return NSSQLiteStoreType
    }
    
    private func migrationPolicy() -> [AnyHashable: Any]? {
        
        return [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
    }
    
    private func mergeModels() -> Bool {
        
        return true
    }
    
    private var savingContext: NSManagedObjectContext {
        
        return contextWithParent(defaultContext)
    }
    
    private func contextWithParent(_ aParentContext: NSManagedObjectContext) -> NSManagedObjectContext {
        
        let result: NSManagedObjectContext = createPrivateQueueContext
        result.parent = aParentContext
        
        return result
    }
    
    private var createPrivateQueueContext: NSManagedObjectContext {
        
        let result: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        return result
    }
    
    private func save(context aContext: NSManagedObjectContext) {
        
        if aContext.hasChanges {
            
            do {
                try aContext.save()
                
                if let parent: NSManagedObjectContext = aContext.parent {
                    
                    save(context: parent)
                }
            } catch {
                
                #if DEBUG
                    print("storage error - \(error)")
                    abort()
                #else
                    aContext.rollback()
                #endif
            }
        }
    }
    
    // MARK: - IDBStorage
    
    func defaultContext(block aBlock: @escaping (NSManagedObjectContext) -> Void) {
        
        defaultContext.perform {
            
            aBlock(self.defaultContext)
        }
    }

    func defaultContextAndWait(block aBlock: @escaping (NSManagedObjectContext) -> Void) {
        
        defaultContext.performAndWait {
            
            aBlock(self.defaultContext)
        }
    }
    
    func save(block aBlock: @escaping (NSManagedObjectContext) -> Void, completion aCompletion: (() -> Void)?) {
        
        let savingContext: NSManagedObjectContext = self.savingContext
        
        savingContext.perform {
            aBlock(savingContext)
            
            self.save(context: savingContext)
            
            if let completion: () -> Void = aCompletion {
                
                completion()
            }
        }
    }
    
    func saveAndWait(block aBlock: (NSManagedObjectContext) -> Void, completion aCompletion: (() -> Void)?) {
        
        let savingContext: NSManagedObjectContext = self.savingContext
        
        savingContext.performAndWait {
            
            aBlock(savingContext)
            self.save(context: savingContext)
            
            if let completion: () -> Void = aCompletion {
                
                completion()
            }
        }
    }

    func removeAllEntitiesWithName(_ anEntityName: String, completion: (() -> Void)?) {
        
        self.saveAndWait(block: { context in
            let entitiesRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>()
            entitiesRequest.entity = NSEntityDescription.entity(forEntityName: anEntityName, in: context)
            entitiesRequest.includesPropertyValues = false
            
            var aError: Error?
            var entities: [AnyObject]
            
            do {
                entities = try context.fetch(entitiesRequest)
                
                for object: AnyObject in entities {
                    
                    if let object: NSManagedObject = object as? NSManagedObject {
                        
                        context.delete(object)
                    }
                }
            } catch {
                
                aError = error
            }
            
            if aError != nil {
                
                print("STStorage: remove entities with error: \(String(describing: aError))")
            }
        }, completion: completion)
    }

    func remove(object aObject: NSManagedObject, completion: (() -> Void)?) {
        
        self.saveAndWait(block: { context in
            
            if let obj: NSManagedObject = aObject.inContext(context) {
                
                context.delete(obj)
            }
        }, completion: completion)
    }
    
    func remove(objects aObjects: [NSManagedObject], completion: (() -> Void)?) {
        
        self.saveAndWait(block: { context in
            
            for object: NSManagedObject in aObjects {
                
                if let obj: NSManagedObject = object.inContext(context) {
                    
                    context.delete(obj)
                }
            }
        }, completion: completion)
    }
}
