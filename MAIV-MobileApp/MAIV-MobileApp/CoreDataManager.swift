//
//  CoreDataManager.swift
//  MAIV-MobileApp
//
//  Created by Jens Van Steen on 11/06/2018.
//  Copyright © 2018 Team 7 - MAIV. All rights reserved.
//

//import CoreData
//
//extension NSEntityDescription {
//
//    static func object<T : NSManagedObject>(into context : NSManagedObjectContext) -> T {
//
//        return insertNewObject(forEntityName: String(describing: T.self), into: context) as! T
//    }
//}
//
//
////extension Painting {
////
////    func configure(with codable : PaintingCodable) {
////
////
////        name = codable.name
////        year = Int16(codable.year)
////        id = codable.id
////    }
////}
//
////extension Tour {
////
////    func configure(with codable : TourCodable) {
////
////        id = codable.id
////        title = codable.title
////        img = codable.img
////        text = codable.text
////        completed = Int16(codable.completed)
////        highlighted = codable.highlighted
////    }
////}
//
//
//
//
//
//class CoreDataManager {
//
//
//    func loadFromData () {
//
////
////        let contentAPI = ContentAPI.shared
////
////        let guidesCodable = contentAPI.guides
////        let artistsCodable = contentAPI.artists
////        let paintingsCodable = contentAPI.paintings
////        let toursCodable = contentAPI.tours
////
////
////        //Parse them
////
////
////        for artistCodable in artistsCodable {
////
////            let artist : Artist = NSEntityDescription.object(into: context)
////
////            artist.configure(with: artistCodable)
////
////        }
////
////        for guideCodable in guidesCodable {
////
////            let guide : Guide = NSEntityDescription.object(into: context)
////
////            guide.configure(with: guideCodable)
////
////        }
////
////
////        for tourCodable in toursCodable {
////
////            let tour : Tour = NSEntityDescription.object(into: context)
////
////            tour.configure(with: tourCodable)
////
////        }
////
////        for paintingCodable in paintingsCodable {
////
////            let painting : Painting = NSEntityDescription.object(into: context)
////
////            painting.configure(with: paintingCodable)
////        }
////
//
//        saveContext()
//    }
//
//
//      func reset () {
//////        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Guide")
//////        let request = NSBatchDeleteRequest(fetchRequest: fetch)
////
////
//////        let delegate = UIApplication.shared.delegate as! AppDelegate
////
////        print("excuted")
////
////        var context : NSManagedObjectContext { return persistentContainer.viewContext }
////
////        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Guide")
////        let deleteFetch2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Tour")
////        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
////        let deleteRequest2 = NSBatchDeleteRequest(fetchRequest: deleteFetch2)
////
////        do {
////            try context.execute(deleteRequest)
////            try context.save()
////        } catch {
////            print ("There was an error")
////        }
////
////
////        do {
////            try context.execute(deleteRequest2)
////            try context.save()
////        } catch {
////            print ("There was an error")
////        }
////
//     }
//
//    func fetch<T : NSFetchRequestResult>(entityName : String, ofType coreDataType : T.Type) -> Array<T>? {
//
//        do {
//            let entities = try context.fetch(NSFetchRequest<T>(entityName: entityName))
//            return entities
//        } catch {
//            print(error)
//        }
//
//        return []
//    }
//
////    lazy var guides : Array<Guide> = fetch(entityName: "Guide", ofType: Guide.self)!
////
////    lazy var artists : Array<Artist> = fetch(entityName: "Artist", ofType: Artist.self)!
////
////    lazy var paintings : Array<Painting> = fetch(entityName: "Painting", ofType: Painting.self)!
////
////    lazy var tours : Array<Tour> = fetch(entityName: "Tour", ofType: Tour.self)!
//
//    static let shared = CoreDataManager()
//
//    lazy var persistentContainer : NSPersistentContainer = {
//
//        let container = NSPersistentContainer(name: "Model")
//
//        container.loadPersistentStores(completionHandler: { (description, error) in
//
//            if let error = error as? Error {
//                fatalError(error.localizedDescription)
//            }
//        })
//
//        return container
//    }()
//
//    var context : NSManagedObjectContext { return persistentContainer.viewContext }
//
//
//    func saveContext () {
//
//        if context.hasChanges {
//
//            do {
//                try context.save()
//
//            } catch {
//
//                fatalError(error.localizedDescription)
//            }

//        }
//    }
//
//}
