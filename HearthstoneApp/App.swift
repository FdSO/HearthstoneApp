import SwiftUI

fileprivate let rootView: some View = CardList.Factory.createView()

@main
fileprivate struct MainApp {
    static func main() {
        if #available(iOS 14.0, *) {
            NewApp.main()
        } else {
            OldApp.main()
        }
    }
}

@available(iOS 14.0, *)
fileprivate struct NewApp: App {
    var body: some Scene {
        WindowGroup {
            rootView
        }
    }
}

fileprivate final class OldApp: UIResponder, UIApplicationDelegate {}

// Info.plist: Add
// Application Scene Manifest / Scene Configuration /
// Application Session Rule / Item 0 / Delegate Class Name
// $(PRODUCT_MODULE_NAME).SceneDelegate

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        window = .init(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: rootView)
        window?.makeKeyAndVisible()
    }
}
