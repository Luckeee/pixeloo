//
//  DataManager.swift
//  pixeloo
//
//  Created by hata on 2019/5/7.
//  Copyright © 2019 hata. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var DataInDB = [History]()

class DataManager{
    
    // Fetches core data context needed for all loading/storing requests.
    public class func getCoreDataContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    public static func GetAllHistorys(callback: (([CanvasData]) -> Void)? = nil){
        guard let managedContext = getCoreDataContext() else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) {(result : NSAsynchronousFetchResult!) in
 
            //对返回的数据做处理。
            let fetchObject = result.finalResult as! [History]
            
            DataInDB = fetchObject
            
            var ret = [CanvasData]()
            
            for h in fetchObject {
                ret.append(CanvasData(data: h))
            }
            
            callback?(ret)
        }

        // 执行异步请求调用execute
        do {
            try managedContext.execute(asyncFetchRequest)
        } catch  {
            print("error")
        }
    }
    
    public static func Save(data: CanvasData){
        guard let context = getCoreDataContext() else {
            return
        }
        do {
            
            let indx = GetHistoryIdx(id: data.id)
            if indx != nil {
                DataInDB[indx!].Updata(data: data)
            }else{
                DataInDB.append(History(data:data))
            }

            //保存实体对象
            try context.save()
        } catch  {
            let nserror = error as NSError
            fatalError("错误:\(nserror),\(nserror.userInfo)")
        }
    }
    
    public static func delete(data: CanvasData) {
        // Grab Core Data context.
        guard let managedContext = getCoreDataContext() else {
            return
        }
        
        let indx = GetHistoryIdx(id: data.id)
        if indx != nil {
            DataInDB.remove(at: indx!)
        }
        
        // Perform actual deletion request.
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        deleteFetch.predicate = NSPredicate(format: "id == %@", data.id as CVarArg)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch let error as NSError {
            // FIXME: Implement proper error handling.
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }

    static func GetHistoryIdx(id :UUID) -> Int? {
        for d in 0..<DataInDB.count {
            if DataInDB[d].id == id {
                return d
            }
        }
        return nil
    }
}

