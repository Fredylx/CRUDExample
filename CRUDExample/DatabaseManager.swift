//
//  DatabaseManager.swift
//  CRUDExample
//
//  Created by Nicky Taylor on 2/1/23.
//

import Foundation
import CoreData

class DatabaseManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let result = NSPersistentContainer(name: "CoreDataBasicExample")
        result.loadPersistentStores { (description, error) in
            if let error = error {
                print("Database Load Error: \(error.localizedDescription)")
            }
        }
        return result
    }()
    
    private var randomNames = ["Oliver", "Meowcifer", "Princess", "Cinnamon", "Calista", "Cali", "Roku", "Fluffy Lumpkins", "FlufferNutterz"]
    private var randomColors = ["Orange", "White", "Black", "Striped", "Greenish"]
    
    func makeKitty() -> KittyKat? {
        
        let context = self.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "KittyKat", in: context) else {
            print("Entity Not Found, KittyKat")
            return nil
        }
        
        let kitty = KittyKat(entity: entity, insertInto: context)
        kitty.name = randomNames.randomElement()
        kitty.color = randomColors.randomElement()
        kitty.tail = makeTail()
        kitty.paws = makePaws()
        
        saveContext()
        
        return kitty
    }
    
    private func makeTail() -> Tail? {
        let context = self.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Tail", in: context) else {
            print("Entity Not Found, Tail")
            return nil
        }
        
        let tail = Tail(entity: entity, insertInto: context)
        tail.length = Double.random(in: 12.0...18.0)
        tail.thickness = Double.random(in: 1.6...2.75)
        return tail
    }
    
    private func makePaws() -> Paws? {
        let context = self.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Paws", in: context) else {
            print("Entity Not Found, Paws")
            return nil
        }
        
        let paws = Paws(entity: entity, insertInto: context)
        paws.beany = Bool.random()
        paws.sharp = Bool.random()
        return paws
    }
    
    func fetchKitty() -> KittyKat? {
        let context = persistentContainer.viewContext
        let request = KittyKat.fetchRequest()
        do {
            let results = try context.fetch(request)
            if let kitty = results.first {
                return kitty
            }
        } catch let error {
            print("CoreData Fetch Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func updateKittyName(kitty: KittyKat?, name: String) {
        if let kitty = kitty {
            kitty.name = name
            saveContext()
        }
    }
    
    func deleteKitty(kitty: KittyKat?) {
        if let kitty = kitty {
            let context = persistentContainer.viewContext
            context.delete(kitty)
            saveContext()
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print("Save Context Error: \(error.localizedDescription)")
            }
        }
    }
    
    
}
