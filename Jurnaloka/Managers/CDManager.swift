//
//  CDManager.swift
//  Wallsmart
//
//  Created by naufalazizz on 05/01/22.
//

// tutorial azamsharp
import Foundation
import CoreData

class CDManager {
    static let shared = CDManager()
    var persistentContainer: NSPersistentContainer!
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Jurnaloka")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }
    
    func updateMovie() {
            
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
        
    }
    
    func getAllPemasukan() -> [Pemasukan] {
        let fetchRequest: NSFetchRequest<Pemasukan> = Pemasukan.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func getAllPengeluaran() -> [Pengeluaran] {
        let fetchRequest: NSFetchRequest<Pengeluaran> = Pengeluaran.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func hapusPemasukan(pemasukan: Pemasukan) {
        
        persistentContainer.viewContext.delete(pemasukan)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context \(error)")
        }
        
    }
    
    func hapusPengeluaran(pengeluaran: Pengeluaran) {
        
        persistentContainer.viewContext.delete(pengeluaran)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context \(error)")
        }
        
    }
    
    func simpanPemasukan(kate_In: String, desk_In: String) {
        let letPemasukan = Pemasukan(context: persistentContainer.viewContext)
        letPemasukan.id_kategori = kate_In
        letPemasukan.deskripsi = desk_In
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save movie \(error)")
        }
    }
    
    func getAllKategori() -> [Kategori] {
        let fetchRequest: NSFetchRequest<Kategori> = Kategori.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func hapusKategori(kategori: Kategori) {
        
        persistentContainer.viewContext.delete(kategori)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context \(error)")
        }
        
    }
}
// close tutorial azamsharp
