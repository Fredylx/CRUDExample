//
//  ViewModel.swift
//  CRUDExample
//
//  Created by Nicky Taylor on 2/1/23.
//

import Foundation

class ViewModel {
    
    let databaseManager = DatabaseManager()
    
    var kitty: KittyKat? {
        didSet {
            updateHandler?()
        }
    }
    
    var updateHandler: (() -> Void)?
    
    func bind(handler: @escaping () -> ()) {
        self.updateHandler = handler
    }
    
    func kittyDescription() -> String {
        guard let kitty = kitty else {
            return "No Kitty"
        }
        
        var thickness = 2.0
        var length = 16.0
        
        var sharp = false
        var beany = false
        
        if let tail = kitty.tail {
            thickness = tail.thickness
            length = tail.length
        }
        
        if let paws = kitty.paws {
            sharp = paws.sharp
            beany = paws.beany
        }
        
        var name = "Oliver"
        if let _name = kitty.name {
            name = _name
        }
        
        var color = "Black"
        if let _color = kitty.color {
            color = _color
        }
        
        let bs = String(UnicodeScalar(8))
        let str =
        """
            My darling Kitty Kat \(name) is a \(color) cat with a pretty tail that is \(String(format: "%.1f", thickness)) inches thick and \(String(format: "%.1f", length)) inches long and his paws are \((beany ? bs : "not")) beany and \((sharp ? bs : "not")) sharp.
        """
        return str
        
    }
}

extension ViewModel {
    
    // [C] Create
    func makeKittyIntent() {
        kitty = databaseManager.makeKitty()
    }
    
    // [R] Read
    func loadKittyIntent() {
        kitty = databaseManager.fetchKitty()
    }
    
    // [U] Update
    func renameKittyIntent(newName name: String?) {
        if let name = name {
            databaseManager.updateKittyName(kitty: kitty, name: name)
            updateHandler?()
        }
    }
    
    // [D] Delete
    func deleteKittyIntent() {
        databaseManager.deleteKitty(kitty: kitty)
        self.kitty = nil
    }
    
}
