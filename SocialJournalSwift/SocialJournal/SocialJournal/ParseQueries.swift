//
//  ParseQueries.swift
//  SocialJournal
//
//  Created by Gabe on 11/19/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import Foundation

class ParseQueries {
    
    
    class func queryForFollowing(currentUser:PFUser!) -> PFQuery {
        var query:PFQuery = PFQuery(className: "Activity")
        query.whereKey("fromUser", equalTo: currentUser)
        query.whereKey("type", equalTo: "follow")
        return query
    }
    
    class func queryForFollowers(currentUser:PFUser!) -> PFQuery {
        var query:PFQuery = PFQuery(className: "Activity")
        query.whereKey("toUser", equalTo: currentUser)
        query.whereKey("type", equalTo: "follow")
        return query
    }
    
    class func queryForAllUsers(currentUser:PFUser!) -> PFQuery {
        var query:PFQuery = PFUser.query()
        query.whereKey("objectId", notEqualTo: currentUser.objectId)
        return query
    }
    
    class func queryForEntries(currentUser:PFUser!) -> PFQuery {
        var followingQuery:PFQuery = PFQuery(className: "Activity")
        followingQuery.whereKey("fromUser", equalTo: currentUser)
        followingQuery.whereKey("type", equalTo: "follow")
        
        var entryQuery:PFQuery = PFQuery(className: "Entry")
        entryQuery.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
        entryQuery.orderByDescending("createdAt")
        
        return entryQuery
    }
    
    class func queryForMyEntries(currentUser:PFUser!) -> PFQuery {
        var entryQuery = PFQuery(className: "Entry")
        entryQuery.whereKey("user", equalTo: currentUser)
        entryQuery.orderByDescending("createdAt")
        return entryQuery
    }
    class func queryForNotifications(currentUser:PFUser!) -> PFQuery {
        var query = PFQuery(className: "Activity")
        query.whereKey("toUser", equalTo: currentUser)
        query.orderByDescending("createdAt")
        return query
    }
    
    class func queryForAllEntries() -> PFQuery {
        var query = PFQuery(className: "Entry")
        query.orderByDescending("createdAt")
        return query
    }
    
    //////////Old Queries Depracated
    
    
    class func getFollowing(currentUser:PFUser) -> [PFObject] {
        var query = PFQuery(className: "Followers")
        query.whereKey("user", equalTo: currentUser)
        return query.findObjects() as [PFObject]
    }
    
    class func getFollowers(currentUser:PFUser) -> [PFObject] {
        var query = PFQuery(className: "Followers")
        query.whereKey("following", equalTo: currentUser)
        return query.findObjects() as [PFObject]
    }
    
    class func getEntriesFromUser(user:PFUser) -> [PFObject] {
        var query = PFQuery(className: "Entry")
        query.whereKey("user", equalTo: user) 
        return query.findObjects() as [PFObject]
    }
    
    class func getAllEntriesForCurrentUser(currentUser:PFUser!) -> [PFObject] {
        var following:[PFObject] = getFollowing(currentUser)
        return following.map({ followed -> [PFObject] in return self.getEntriesFromUser(followed["following"] as PFUser )}).reduce([],+)
    }
    
    class func getTagsForEntry(entry:PFObject) -> [String] {
        var queryForTags = PFQuery(className: "TagMap")
        queryForTags.whereKey("entry", equalTo: entry)
        return (queryForTags.findObjects() as [PFObject]).map({ (tag:PFObject) -> String in return tag["tag"] as String })
    }
    
    class func getHeartCountForEntry(entry:PFObject) -> Int {
        var queryForHeartCount = PFQuery(className: "Activity")
        queryForHeartCount.whereKey("type", equalTo: "like")
        queryForHeartCount.whereKey("entry", equalTo: entry)
        return queryForHeartCount.countObjects()
    }
    
    class func followUser(currentUser: PFUser, userToFollow: PFUser) {
        var newFollows = PFObject(className: "Following")
        newFollows["user"] = currentUser
        newFollows["following"] = userToFollow
        newFollows.saveEventually()
    }
    
//    class func unFollowUser(currentUser: PFUser, userToFollow: PFUser) {
//        var userQuery = PFQuery(className: "Followers")
//        userQuery.whereKey("user", equalTo: currentUser)
//        var users
//    }
    
}