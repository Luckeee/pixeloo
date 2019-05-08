//
//  History+CoreDataProperties.swift
//
//
//  Created by hata on 2019/5/7.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
import UIKit

@objc(History)
class History: NSManagedObject {
    
    convenience init(data: CanvasData) {
        self.init(context: DataManager.getCoreDataContext()!)
        self.id = data.id
        self.width = data.width
        self.height = data.height
        self.palette = data.palette_colors
        self.imagedata = data.imagedata
        self.historys = data.historys
    }
    
    func Updata(data: CanvasData) {
        self.id = data.id
        self.width = data.width
        self.height = data.height
        self.palette = data.palette_colors
        self.imagedata = data.imagedata
        self.historys = data.historys
    }
    
}

extension History {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }
    
    @NSManaged public var height: Int64
    @NSManaged public var historys: [[[UIColor]]]?
    @NSManaged public var id: UUID
    @NSManaged public var imagedata: NSData?
    @NSManaged public var palette: [UIColor]?
    @NSManaged public var width: Int64
    
}

class CanvasData : Equatable{
    
    init() {
        
        self.id = .init()
        self.width = 64
        self.height = 64
        self.palette_colors = nil
        self.imagedata = nil
        self.historys = nil
        
    }
    
    init(data: History) {
        
        self.id = data.id
        self.width = data.width
        self.height = data.height
        self.palette_colors = data.palette
        self.imagedata = data.imagedata
        self.historys = data.historys
        
    }
    
    static func == (lhs: CanvasData, rhs: CanvasData) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var height: Int64 = 64
    public var historys: [[[UIColor]]]?
    public var id: UUID = .init()
    public var imagedata: NSData?
    public var palette_colors: [UIColor]?
    public var width: Int64 = 64
    
}
