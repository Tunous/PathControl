# PathControl

SwiftUI wrapper for `NSPathControl`.

```swift
PopUpPathControl(url: $url) { menuItems in
    PathMenuItem.fileChooser(title: "Select project…")
    
    if menuItems.contains(where: { $0.title == "Users" }) {
        Divider()
        PathMenuItem(title: "Viewing contents of Users directory")
    }
    
    Divider()
    
    menuItems
}
```