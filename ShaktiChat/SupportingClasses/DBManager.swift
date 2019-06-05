//
//  DBManager.swift
//  FMDBTut
//
//  Created by Gabriel Theodoropoulos on 07/10/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class DBManagerChat: NSObject {
    
    var db: OpaquePointer?
    var statement: OpaquePointer?
    static let sharedInstance: DBManagerChat = DBManagerChat()
    
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    var pathToDatabase: String!
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/chatName.db")
        print("pathToDatabase --->",pathToDatabase)
    }
    
    
    func CreateOpenDB() { //Create/open database.
        
        //        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        //            .appendingPathComponent("chatName.db")
        
        // open database
        if sqlite3_open(pathToDatabase, &db) == SQLITE_OK {
            print("error opening database")
            
            if sqlite3_exec(db, "create table if not exists ChatTable (Incid integer primary key autoincrement not null, delivery_type text not null, direction text not null, downloading text not null, file_path text not null, group_id text not null, id text not null, msg text not null, msg_from text not null, msg_timestamp text not null, msg_to text not null, msg_type text not null, name text not null, pk_chat_id text not null, status text not null, topic text not null, topic_id text not null, xmpp_user text not null, date text not null,extra text not null, file text not null, file_name text not null,group_name text not null,time text not null, type text not null, reply_id text not null)", nil, nil, nil) != SQLITE_OK {
                print("CreateTable error creating table: \(sqlite3_errmsg(db)!)")
            }else {
                print("CreateTable creating successfull")
            }
            //   closeDatabase()
        }else {
            
            print("CreateTable error creating table: \(sqlite3_errmsg(db)!)")
            
        }
    }
    
    func closeDatabase() {
        
        //        if sqlite3_close(db) != SQLITE_OK {
        //            print("error closing database")
        //        }
        //        db = nil
    }
    
    func deleteMessage(query: String, completionHandler: @escaping (Any?) -> Swift.Void){ //Use sqlite3_prepare_v2 to prepare SQL with ? placeholder to which we'll bind value.
        print(" query--\(query)")
        // open database
        if sqlite3_open(pathToDatabase!, &db) == SQLITE_OK {
            if sqlite3_prepare(db, query, -1, &statement, nil) == SQLITE_OK{
                if sqlite3_step(statement) == SQLITE_DONE{
                    print("Successfully deleted row.")
                    closeDatabase()
                    completionHandler(1)
                }
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                closeDatabase()
                completionHandler(nil)
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            
        }
        
    }
    
    func prepareToInsert(query: String, completionHandler: @escaping (Any?) -> Swift.Void) { //Use sqlite3_prepare_v2 to prepare SQL with ? placeholder to which we'll bind value.
        //"insert into test (name) values (?)" //prepareStatement
        //print("query-\(query)-")
        //        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        //            .appendingPathComponent(nameDatabase)
     //   print(" query--\(query)")
        // open database
        if sqlite3_open(pathToDatabase!, &db) == SQLITE_OK {
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
            }
            
            if sqlite3_step(statement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting foo: \(errmsg)")
                completionHandler(nil)
                
            }else {
                completionHandler(1)
            }
          
        }
        
    }
    
    
    
    
    
    func DatabaseToGatValues(query: String, completionHandler: (NSMutableArray?) -> Void) { //Prepare new statement for selecting values from table and loop through retrieving the values:
        print("query select: \(query)")
        
        //"select id, name from test"
        if sqlite3_open(pathToDatabase!, &db) == SQLITE_OK {
            let arr = NSMutableArray()

            if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
                completionHandler(nil)
            } else {
                
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    //   var y: Int32 = 0
                    let dictChat = NSMutableDictionary()
                    dictChat["IncId"] = sqlite3_column_int64(statement, 0)
//                    if let cName = sqlite3_column_text(statement, 1) {
//                        dictChat["bubblearrow"] = String(cString: cName)
//                    }
//                    
//                    if let cName = sqlite3_column_text(statement, 2) {
//                        dictChat["dateview"] = String(cString: cName)
//                    }
                    if let cName = sqlite3_column_text(statement, 1) {
                        dictChat["delivery_type"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 2) {
                        dictChat["direction"] = String(cString: cName)
                    }
                    
                    if let cName = sqlite3_column_text(statement, 3) {
                        dictChat["downloading"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 4) {
                        dictChat["file_path"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 5) {
                        dictChat["group_id"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 6) {
                        dictChat["id"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 7) {
                        dictChat["msg"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 8) {
                        dictChat["msg_from"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 9) {
                        dictChat["msg_timestamp"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 10) {
                        dictChat["msg_to"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 11) {
                        dictChat["msg_type"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 12) {
                        dictChat["name"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 13) {
                        dictChat["pk_chat_id"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 14) {
                        dictChat["status"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 15) {
                        dictChat["topic"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 16) {
                        dictChat["topic_id"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 17) {
                        dictChat["xmpp_user"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 18) {
                        dictChat["date"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 19) {
                        dictChat["extra"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 20) {
                        dictChat["file"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 21) {
                        dictChat["file_name"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 22) {
                        dictChat["group_name"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 23) {
                        dictChat["time"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 24) {
                        dictChat["type"] = String(cString: cName)
                    }
                    if let cName = sqlite3_column_text(statement, 25) {
                        dictChat["reply_id"] = String(cString: cName)
                    }
                    
                    
                    arr.add(dictChat)
                    //   var str = ""
                    //   print("record -\(str)-")
                    //uploadGeoTagPicture(dictOffline: dict)
                    
                }
                completionHandler(arr)

            }
            
            
//            if sqlite3_finalize(statement) != SQLITE_OK {
//                let errmsg = String(cString: sqlite3_errmsg(db)!)
//                completionHandler(nil)
//                print("error finalizing prepared statement: \(errmsg)")
//            }else {
//            }

         //   print("arr----\(arr)")
        }else {
            completionHandler(nil)
        }
        //  statement = nil
        // completionHandler(&statement, db)
        
    }
    
    func getLastId(query:String) -> Int {
        var id = 0 // "select * from ChatTable"
        if sqlite3_open(pathToDatabase!, &db) == SQLITE_OK {
            
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
            while sqlite3_step(statement) == SQLITE_ROW {
                
                id = id + 1
                //                    let dictChat = NSMutableDictionary()
                //                    dictChat.setValue(Int(results.int(forColumn: "IncId")), forKey: "IncId")
            }
           // sqlite3_finalize(statement)
            
            
            closeDatabase()
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error finalizing prepared statement: \(errmsg)")
            }
            return id
        }else {
            
        }
        return id
        
    }
    
    /////
}

/*
class DBManager: NSObject {

    let field_MovieID = "movieID"
    let field_MovieTitle = "title"
    let field_MovieCategory = "category"
    let field_MovieYear = "year"
    let field_MovieURL = "movieURL"
    let field_MovieCoverURL = "coverURL"
    let field_MovieWatched = "watched"
    let field_MovieLikes = "likes"
    
    
    static let shared: DBManager = DBManager()
    let databaseFileName = "chatDatabase.sqlite"
    var pathToDatabase: String!
    var database: FMDatabase!
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        print("pathToDatabase --->",pathToDatabase)
        
        
    }
    

    func createmessagecontact()-> Bool{
        var created = false

        if FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            if database != nil {
                // Open the database.
                
                if database.open() {
                    //                 //    let query =   "insert into messagecontact (Incid , btrtlTxt, category, name, pernr, pernr10, pic,  pk_user_id, telnr, xmpp_id, badgeCount) values (null, '\(string(dict, "btrtlTxt"))', '\(string(dict, "category"))', '\(string(dict, "name"))', '\(string(dict, "pernr10"))', '\(string(dict, "telnr"))', '\(string(dict, "pernr"))', '\(string(dict, "pic"))', '\(string(dict, "pk_user_id"))', '\(string(dict, "xmpp_id"))', '0')"
                    
                    //     DBManager.shared.insertChatData(query: query)

                    let createChatableQuery =  "create table if not exists messagecontact (Incid integer primary key autoincrement not null, btrtlTxt text not null,category text not null, name text not null, pernr text not null, pernr10 text not null, pic text not null,  pk_user_id text not null, telnr text not null, xmpp_id  text not null, badgeCount text not null)"
                    do {
                        try database.executeUpdate(createChatableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("messagecontact Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                } else {
                    print("Could not open the database.")
                }
                
            }
        }
        return created

    }
    
    
    
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            if database != nil {
                // Open the database.
                if database.open() {
                    let createChatableQuery =  "create table if not exists ChatTable (Incid integer primary key autoincrement not null, bubblearrow text not null, dateview text not null, delivery_type text not null, direction text not null, downloading text not null, file_path text not null, group_id text not null, id text not null, msg text not null, msg_from text not null, msg_timestamp text not null, msg_to text not null, msg_type text not null, name text not null, pk_chat_id text not null, status text not null, topic text not null, topic_id text not null, xmpp_user text not null, date text not null,extra text not null, file text not null, file_name text not null,group_name text not null,time text not null, type text not null, reply_id text not null)"
                    // ,date text not null,extra text not null, file text not null, file_name text not null,group_name text not null,time text not null, type text not null
                    
                 //   let createMoviesTableQuery = "create table movies (\(field_MovieID) integer primary key autoincrement not null, \(field_MovieTitle) text not null, \(field_MovieCategory) text not null, \(field_MovieYear) integer not null, \(field_MovieURL) text, \(field_MovieCoverURL) text not null, \(field_MovieWatched) bool not null default 0, \(field_MovieLikes) integer not null)"
                    
                    do {
                        try database.executeUpdate(createChatableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    
                    database.close()
                } else {
                    print("Could not open the database.")
                }
                
                
            }
        }
        
        

        
    /*    if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            print("pathToDatabase --->",pathToDatabase)
            if database != nil {
                // Open the database.
                if database.open() {
                    let groupcontact =  "create table if not exists groupcontact (Incid integer primary key autoincrement not null, created_by text not null, groupName text not null,  groupNo  text not null, group_id text not null, group_type text not null, badgeCount integer not null)"
                    do {
                        try database.executeUpdate(groupcontact, values: nil)
                    }
                    catch {
                        print("groupcontact Could not create table.")
                        print(error.localizedDescription)
                    }
                    database.close()
                } else {
                    print("Could not open the database.")
                }
                
            }
        }
        */
        return created
    }
    
    func deleteChatMessage(withquery query: String,values: [Any]?) -> Bool {
        var deleted = false
        
        if openDatabase() {
         //   let query = "delete from ChatTable where pk_chat_id=?"
            
            do {
                try database.executeUpdate(query, values: values)
                deleted = true
                print("query--\(query)")

            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return deleted
    }
    func getmessageContactList(query:String, completionHandler: @escaping (Any?) -> Swift.Void)  {
        let arr = NSMutableArray()
        // var movies: [MovieInfo]!
        //    print("query -------\(query)----values----\(String(describing: values))")
        if openDatabase() {
            do {
                print(database)
                let results = try database.executeQuery(query, values: nil)
                
              while results.next() {
                
                    let dictChat = NSMutableDictionary()
                    dictChat.setValue(Int(results.int(forColumn: "IncId")), forKey: "IncId")
                    
                    dictChat.setValue(results.string(forColumn: "btrtlTxt"), forKey: "btrtlTxt")
                    dictChat.setValue(results.string(forColumn: "category"), forKey: "category")
                    dictChat.setValue(results.string(forColumn: "name"), forKey: "name")
                    dictChat.setValue(results.string(forColumn: "pernr"), forKey: "pernr")
                    dictChat.setValue(results.string(forColumn: "pernr10"), forKey: "pernr10")
                
                    dictChat.setValue(results.string(forColumn: "pic"), forKey: "pic")
                    dictChat.setValue(results.string(forColumn: "pk_user_id"), forKey: "pk_user_id")
                
                    dictChat.setValue(results.string(forColumn: "telnr"), forKey: "telnr")
                    dictChat.setValue(results.string(forColumn: "xmpp_id"), forKey: "xmpp_id")
                    dictChat.setValue(results.string(forColumn: "badgeCount"), forKey: "badgeCount")
                
                    arr.add(dictChat)
                }
              
                completionHandler(arr)
            }
            catch {
                completionHandler(nil)
                
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        //     return arr
    }

    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func getLastId() -> Int {
        var id = 0
        if openDatabase() {
            do {
                print(database)
                
                let results = try database.executeQuery("select * from ChatTable", values: nil)
               
                while results.next() {
                    id = id + 1
//                    let dictChat = NSMutableDictionary()
//                    dictChat.setValue(Int(results.int(forColumn: "IncId")), forKey: "IncId")
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        return id
    }
    
    
    
    func insertChatData(query : String , completionHandler: @escaping (Any?) -> Swift.Void) {
        
        
        if openDatabase() {
         //   print(query)
              //      var query = ""

   //          self.db.prepareStatement(query: "insert into ChatTable (bubblearrow, dateview, delivery_type, direction, downloading, file_path, group_id, id, msg, msg_from, msg_timestamp, msg_to, msg_type, name, pk_chat_id, status, topic, topic_id, xmpp_user, date, extra, file, file_name, group_name, time, type) values (null,  ,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
            
      //      query =   "insert into ChatTable (bubblearrow, dateview, delivery_type, direction, downloading, file_path, group_id, id, msg, msg_from, msg_timestamp, msg_to, msg_type, name, pk_chat_id, status, topic, topic_id, xmpp_user, date, extra, file, file_name, group_name, time, type) values (null,  ,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
            
            
               //      query += "insert into movies (\(field_MovieID), \(field_MovieTitle), \(field_MovieCategory), \(field_MovieYear), \(field_MovieURL), \(field_MovieCoverURL), \(field_MovieWatched), \(field_MovieLikes)) values (null, '\(movieTitle)', '\(movieCategory)', \(movieYear), '\(movieURL)', '\(movieCoverURL)', 0, 0);"
            
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database. -----\(query)---")
                print(database.lastError(), database.lastErrorMessage())
                completionHandler(nil)

            }else {
                completionHandler(1)

            }
            
            database.close()
            
        }
        
        
    }
    
    func getChatHistoryCount(query:String,values: [Any]?) -> Int { // , completionHandler: @escaping (Any?) -> Swift.Void
      //  let arr = NSMutableArray()
        // var movies: [MovieInfo]!
        var diii = 0
        if openDatabase() {
            do {
                
                let results = try database.executeQuery(query, values: values)
            

              //  diii = Int(results.columnCount)
                
                while results.next() {
                    print("id --\(Int(results.int(forColumn: "IncId")))")
                    diii = diii + 1
                }
                if diii > 0 {
                    print("query ---->\(query)<----values---->\(String(describing: values))<-- count-->\(diii)-")
                }

               // completionHandler(diii)
            }
            catch {
               // completionHandler(diii)
                print(error.localizedDescription)
            }
            
            database.close()
            return diii

        }
           return 0
        //     return arr
    }
    func getChatHistory(query:String,values: [Any]?, completionHandler: @escaping (Any?) -> Swift.Void)  {
        let arr = NSMutableArray()
       // var movies: [MovieInfo]!
        print("query -------\(query)----values----\(String(describing: values))")
        if openDatabase() {
            do {
                print(database)
                let results = try database.executeQuery(query, values: values)
                
                while results.next() {
                    
                    let dictChat = NSMutableDictionary()
                    dictChat.setValue(Int(results.int(forColumn: "IncId")), forKey: "IncId")
                
                    dictChat.setValue(results.string(forColumn: "bubblearrow"), forKey: "bubblearrow")
                    
                    dictChat.setValue(results.string(forColumn: "dateview"), forKey: "dateview")
                    dictChat.setValue(results.string(forColumn: "delivery_type"), forKey: "delivery_type")
                    dictChat.setValue(results.string(forColumn: "direction"), forKey: "direction")
                    dictChat.setValue(results.string(forColumn: "downloading"), forKey: "downloading")
                    dictChat.setValue(results.string(forColumn: "file_path"), forKey: "file_path")
                    dictChat.setValue(results.string(forColumn: "group_id"), forKey: "group_id")
                    dictChat.setValue(results.string(forColumn: "id"), forKey: "id")
                    dictChat.setValue(results.string(forColumn: "msg"), forKey: "msg")
                    dictChat.setValue(results.string(forColumn: "msg_from"), forKey: "msg_from")
                    dictChat.setValue(results.string(forColumn: "msg_timestamp"), forKey: "msg_timestamp")
                    dictChat.setValue(results.string(forColumn: "msg_to"), forKey: "msg_to")
                    dictChat.setValue(results.string(forColumn: "msg_type"), forKey: "msg_type")
                    dictChat.setValue(results.string(forColumn: "name"), forKey: "name")
                    dictChat.setValue(results.string(forColumn: "pk_chat_id"), forKey: "pk_chat_id")
                    dictChat.setValue(results.string(forColumn: "status"), forKey: "status")
                    dictChat.setValue(results.string(forColumn: "topic"), forKey: "topic")
                    dictChat.setValue(results.string(forColumn: "topic_id"), forKey: "topic_id")
                    dictChat.setValue(results.string(forColumn: "xmpp_user"), forKey: "xmpp_user")
                    dictChat.setValue(results.string(forColumn: "date"), forKey: "date")
                    dictChat.setValue(results.string(forColumn: "extra"), forKey: "extra")
                    dictChat.setValue(results.string(forColumn: "file"), forKey: "file")

                    dictChat.setValue(results.string(forColumn: "file_name"), forKey: "file_name")
                    dictChat.setValue(results.string(forColumn: "group_name"), forKey: "group_name")
                    dictChat.setValue(results.string(forColumn: "time"), forKey: "time")
                    dictChat.setValue(results.string(forColumn: "type"), forKey: "type")
                    dictChat.setValue(results.string(forColumn: "reply_id"), forKey: "reply_id")
  
                    arr.add(dictChat)
                }
                completionHandler(arr)
            }
            catch {
                completionHandler(nil)

                print(error.localizedDescription)
            }
            
            database.close()
        }
        
   //     return arr
    }
    
    
    func updateChatMsg(query:String, values: [Any]?) {
        if openDatabase() {
            print("query ----\(query)---\(values)")
      //      let query = "update movies set \(field_MovieWatched)=?, \(field_MovieLikes)=? where \(field_MovieID)=?"
            
            do {
                try database.executeUpdate(query, values: values)
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
 /*
    func insertMovieData() {
        if openDatabase() {
            if let pathToMoviesFile = Bundle.main.path(forResource: "movies", ofType: "tsv") {
                do {
                    let moviesFileContents = try String(contentsOfFile: pathToMoviesFile)
                    
                    let moviesData = moviesFileContents.components(separatedBy: "\r\n")
                    
                    var query = ""
                    for movie in moviesData {
                        let movieParts = movie.components(separatedBy: "\t")
                        
                        if movieParts.count == 5 {
                            let movieTitle = movieParts[0]
                            let movieCategory = movieParts[1]
                            let movieYear = movieParts[2]
                            let movieURL = movieParts[3]
                            let movieCoverURL = movieParts[4]
                            
                            query += "insert into movies (\(field_MovieID), \(field_MovieTitle), \(field_MovieCategory), \(field_MovieYear), \(field_MovieURL), \(field_MovieCoverURL), \(field_MovieWatched), \(field_MovieLikes)) values (null, '\(movieTitle)', '\(movieCategory)', \(movieYear), '\(movieURL)', '\(movieCoverURL)', 0, 0);"
                        }
                    }
                    
                    if !database.executeStatements(query) {
                        print("Failed to insert initial data into the database.")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            database.close()
        }
    }
    
    
   func loadMovies() -> [MovieInfo]! {
        var movies: [MovieInfo]!
        
        if openDatabase() {
            let query = "select * from movies order by \(field_MovieYear) asc"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let movie = MovieInfo(movieID: Int(results.int(forColumn: field_MovieID)),
                                          title: results.string(forColumn: field_MovieTitle),
                                          category: results.string(forColumn: field_MovieCategory),
                                          year: Int(results.int(forColumn: field_MovieYear)),
                                          movieURL: results.string(forColumn: field_MovieURL),
                                          coverURL: results.string(forColumn: field_MovieCoverURL),
                                          watched: results.bool(forColumn: field_MovieWatched),
                                          likes: Int(results.int(forColumn: field_MovieLikes))
                    )
                    
                    if movies == nil {
                        movies = [MovieInfo]()
                    }
                    
                    movies.append(movie)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return movies
    }
    
    
    func loadMovie(withID ID: Int, completionHandler: (_ movieInfo: MovieInfo?) -> Void) {
        var movieInfo: MovieInfo!
        
        if openDatabase() {
            let query = "select * from movies where \(field_MovieID)=?"
            
            do {
                let results = try database.executeQuery(query, values: [ID])
                
                if results.next() {
                    movieInfo = MovieInfo(movieID: Int(results.int(forColumn: field_MovieID)),
                                          title: results.string(forColumn: field_MovieTitle),
                                          category: results.string(forColumn: field_MovieCategory),
                                          year: Int(results.int(forColumn: field_MovieYear)),
                                          movieURL: results.string(forColumn: field_MovieURL),
                                          coverURL: results.string(forColumn: field_MovieCoverURL),
                                          watched: results.bool(forColumn: field_MovieWatched),
                                          likes: Int(results.int(forColumn: field_MovieLikes))
                    )
                    
                }
                else {
                    print(database.lastError())
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        completionHandler(movieInfo)
    }
    
    
    func updateMovie(withID ID: Int, watched: Bool, likes: Int) {
        if openDatabase() {
            let query = "update movies set \(field_MovieWatched)=?, \(field_MovieLikes)=? where \(field_MovieID)=?"
            
            do {
                try database.executeUpdate(query, values: [watched, likes, ID])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    
    
    func deleteMovie(withID ID: Int) -> Bool {
        var deleted = false
        
        if openDatabase() {
            let query = "delete from movies where \(field_MovieID)=?"
            
            do {
                try database.executeUpdate(query, values: [ID])
                deleted = true
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return deleted
    }
    */
}




struct MovieInfo {
    var movieID: Int!
    var title: String!
    var category: String!
    var year: Int!
    var movieURL: String!
    var coverURL: String!
    var watched: Bool!
    var likes: Int!
}
*/
