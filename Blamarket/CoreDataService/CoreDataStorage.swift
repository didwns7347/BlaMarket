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
        
        context.delete(recode)
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    

    
    @discardableResult func searchAndDelete(keyword:String)->Bool{
        let deleteRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(keyword: keyword)
        do {
            if let results: [SearchRecode] = try context.fetch(deleteRequest) as? [SearchRecode] {
                if results.count != 0 {
                    context.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fatch: \(error), \(error.userInfo)")
        }
        do {
            try context.save()
            print("코어데이터 삭제 성공")
            return true
        } catch {
            context.rollback()
            print("실행 불가능 합니다")
            return false
        }
        return false
    }
    fileprivate func filteredRequest(keyword: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchRecode")
        fetchRequest.predicate = NSPredicate(format: "keyword = %@", "\(keyword)")
        return fetchRequest
    }
    
    
}




