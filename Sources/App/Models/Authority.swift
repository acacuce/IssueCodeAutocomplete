import Vapor
import Foundation
final class Authority: Model {
    
    var id: Node?
    var exists: Bool = false
    
    var issueCode: String
    var name: String
    var endDate: String?
    
    init(issueCode: String, name: String, endDate: String?) {
        self.issueCode = issueCode
        self.name = name
        self.endDate = endDate
        self.id = nil
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        issueCode = try node.extract("code")
        name = try node.extract("name")
        endDate = try node.extract("end_date")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "code": issueCode,
            "name": name,
            "end_date": endDate
        ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("authoritys", closure: { (users) in
            users.id()
            users.string("code")
            users.string("name")
            users.string("end_date", optional: true)
            
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("authoritys")
    }
    
    
    
}
