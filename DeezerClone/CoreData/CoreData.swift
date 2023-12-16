//
//  CoreData.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import UIKit
import CoreData

class CoreData {
    static let shared = CoreData()
    
    var songIdArray = [Int]()
    var songTitleArray = [String]()
    var songImageArray = [String]()
    var songDurationArray = [Int]()
    var songPreview = [String]()
    
    //MARK: Save Data
    func saveCoreData(duration: Int, preview: String, title: String, albumCover: String, songId: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: context)
        print(duration)
        print(preview)
        print(title)
        print(albumCover)
        print(songId)
        favorite.setValue(duration, forKey: "duration")
        favorite.setValue(preview, forKey: "preview")
        favorite.setValue(title, forKey: "title")
        favorite.setValue(albumCover, forKey: "cover")
        favorite.setValue(songId, forKey: "songId")
        
        do {
            try context.save()
            print("Kayıt Başarılı")
        } catch {
            print("Kayıt hatası")
        }
    }
    //MARK: Get Data
    func getCoreData() {
        self.songIdArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let songId = result.value(forKey: "songId") as? Int {
                        print(songId)
                        songIdArray.append(songId)
                    }
                    if let title = result.value(forKey: "title") as? String {
                        print(title)
                    }
                }
            }
        } catch {
            print("Veri alma hatası")
        }
    }
    //MARK: Favorite Get CoreData
    func favoriteGetCoreData() {
        self.songTitleArray.removeAll(keepingCapacity: false)
        self.songDurationArray.removeAll()
        self.songIdArray.removeAll()
        self.songImageArray.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for resultGet in results as! [NSManagedObject] {
                    if let getTitle = resultGet.value(forKey: "title") as? String {
                        //songTitle = getTitle
                        self.songTitleArray.insert(getTitle, at: 0)
                    }
                    if let getImage = resultGet.value(forKey: "cover") as? String {
                        self.songImageArray.insert(getImage, at: 0)
                    }
                    if let songDuration = resultGet.value(forKey: "duration") as? Int {
                        self.songDurationArray.insert(songDuration, at: 0)
                    }
                    if let songId = resultGet.value(forKey: "songId") as? Int {
                        print(songId)
                        songIdArray.insert(songId, at: 0)
                    }
                    if let preview = resultGet.value(forKey: "preview") as? String {
                        songPreview.insert(preview, at: 0)
                    }
                }
            }
        } catch {
            print("Kayıtlı ögeleri atamada hata")
        }
    }
    //MARK: Delete CoreData
    func deleteCoreData(songId: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for resultGet in results as! [NSManagedObject] {
                    if let id = resultGet.value(forKey: "songId") {
                        if id as! Int == songId {
                            context.delete(resultGet)
                            print("Seçilen veri silindi")
                            do {
                                try context.save()
                            } catch {
                                print("Silme işleminden sonra kayıt ederken hata")
                            }
                            break
                        }
                    }
                }
            }
        } catch {
            print("Seçileni silmede hata")
        }
    }
    //MARK: Remove All
    func removeAllCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                context.delete(result)
               try context.save()
                print("Silme başarılı")
            }
        } catch {
            print("Hepsini silmede hata")
        }
    }
}
