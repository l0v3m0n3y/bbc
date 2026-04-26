# bbc
web api for bbc.com Visit BBC for trusted reporting on the latest world and US news, sports, business, climate, innovation, culture and much more.
# main
```swift
import Foundation
import bbc
let client = Bbc()

do {
    let news = try await client.get_news_list(path:"/news/videos/ckgerdnvm2xo")
    print(news)
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swift run
```
