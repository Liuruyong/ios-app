import Foundation
import UIKit

final class AppDAO {

    static let shared = AppDAO()
    static let sqlQueryColumns = "a.app_id, a.app_number, a.redirect_uri, a.name, a.icon_url, a.description, a.capabilites, a.app_secret, a.home_uri"
    static let sqlQueryApps = """
        SELECT \(sqlQueryColumns) FROM participants p, apps a, users u
        WHERE p.conversation_id = ? AND p.user_id = u.user_id AND a.app_id = u.app_id
    """
    static let sqlQueryAppsByUser = """
        SELECT \(sqlQueryColumns) FROM apps a, users u
        WHERE u.user_id = ? AND a.app_id = u.app_id
    """

    func getConversationBots(conversationId: String) -> [App] {
        return MixinDatabase.shared.getCodables(sql: AppDAO.sqlQueryApps, values: [conversationId], inTransaction: false).filter({ (app) -> Bool in
            return app.capabilites?.contains(ConversationCategory.GROUP.rawValue) ?? false
        })
    }

    func getUserBot(userId: String) -> App? {
        return MixinDatabase.shared.getCodables(sql: AppDAO.sqlQueryAppsByUser, values: [userId], inTransaction: false).first
    }
}
