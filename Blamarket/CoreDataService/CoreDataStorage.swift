//
//  CoreDataStorage.swift
//  Blamarket
//
//  Created by yangjs on 2022/10/25.
//

import CoreData
import UIKit



class CoreDataStorage{
    let appDelegate : AppDelegate
    let context : NSManagedObjectContext
    
    init(){
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func saveData(data:String){
        let entity = NSEntityDescription.entity(forEntityName: "SearchRecode", in: context)
        if let entity = entity{
            let searchData = NSManagedObject(entity: entity, insertInto: context)
            searchData.setValue(data, forKey: "keyword")
            searchData.setValue(Date(), forKey: "date")
        }
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func fetchData()->[SearchRecode]{
        do{
            let searchRecodes = try context.fetch(SearchRecode.fetchRequest()) as! [SearchRecode]
            searchRecodes.forEach{
                print($0.keyword! , $0.date!)
            }
            return searchRecodes
        }catch{
            print(error.localizedDescription)
        }
        return []
    }
    
    func deleteData(recode:SearchRecode?){
        guard let recode =  recode else{
            return
        }
        do{
            try context.delete(recode)
            do{
                try context.save()
            }catch{
                print(error.localizedDescription)
            }
        }catch{
            print(error.localizedDescription)
        }
    }

}
