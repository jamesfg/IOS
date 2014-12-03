//
//  Reminder.swift
//  Exercise8
//
//  Created by ubicomp3 on 11/6/14.
//  Copyright (c) 2014 CPL. All rights reserved.
//

import Foundation
class Reminder : NSObject, NSCoding{
    var title: String!
    var location: String!
    var date : NSDate
    
    
    init(newTitle: String, newLocation: String, newDate: NSDate) {
        //<initialize attributes of the object>
        self.title = newTitle
        self.location = newLocation
        self.date = newDate
    }
    
    required init(coder aDecoder: NSCoder) {
    // for each attribute
        self.title = aDecoder.decodeObjectForKey("title") as String
        self.location = aDecoder.decodeObjectForKey("location") as String
        self.date = aDecoder.decodeObjectForKey("date") as NSDate
    }
    func encodeWithCoder(coder: NSCoder) { // for each attribute
        
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.location, forKey: "location")
        coder.encodeObject(self.date, forKey: "date")
        
    }
};