import Vapor
import Foundation
import VaporPostgreSQL
let drop = Droplet(preparations: [Authority.self])

try drop.addProvider(VaporPostgreSQL.Provider.self)



drop.get("autocomplete") { request in
    if let issueCode = request.query?["issue_code"]?.string {
        let url = URL(string: "file://"+"\(drop.workDir)"+"Resources/jsons/issue-code.json")
        let data = try Data.init(contentsOf: url!)
        let bytes = Bytes(data)
        let json = try JSON.init(bytes: bytes)
        
        for row in json.array! {
            if let title = row.object?["title"]?.string, let code = row.object?["code"]?.string {
                let endDate: String? = row.object?["end_date"]?.string
                var authority = Authority.init(issueCode: code, name: title, endDate: endDate)
                try authority.save()
                
            }
        }
        
        return ""
        
//        let authoritys = try Authority.query().filter("code", issueCode).all()
//        let codeFormat: String = "\\d{3}-\\d{3}"
//        let codePredicate = NSPredicate(format:"SELF MATCHES %@", codeFormat)
//        if codePredicate.evaluate(with: issueCode) {
//            return try JSON.init(node: authoritys)
//        }else {
//            throw Abort.badRequest
//        }
    }else {
        throw Abort.badRequest
    }

}

drop.run()
