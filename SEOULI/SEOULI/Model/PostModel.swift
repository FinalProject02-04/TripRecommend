import Foundation

struct PostModel: Identifiable, Codable {
    var id: String
    var title: String
    var username: String
    var subtitle: String
    var content: String
    var date: String
    var image: String
    var views: Int
    
    init(id: String = UUID().uuidString, title: String, username: String, subtitle: String, content: String, date: String, image: String, views: Int = 0) {
        self.id = id
        self.title = title
        self.username = username
        self.subtitle = subtitle
        self.content = content
        self.date = date
        self.image = image
        self.views = views
    }
}

