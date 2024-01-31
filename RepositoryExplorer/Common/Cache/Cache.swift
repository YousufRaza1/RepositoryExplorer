
//
//  RepositoryExplorer
//
//  Created by Yousuf on 1/30/24.
//

import Foundation

protocol Cache: Actor {
    associatedtype V
    var expirationInterval: TimeInterval { get }

    func setValue(_ value: V?, forKey key: String)
    func value(forKey key: String) -> V?

    func removeValue(forKey key: String)
    func removeAllValues()
}
