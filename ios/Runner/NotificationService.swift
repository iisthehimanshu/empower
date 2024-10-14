import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent,
              let imageUrlString = request.content.userInfo["image-url"] as? String,
              let imageUrl = URL(string: imageUrlString) else {
            contentHandler(request.content)
            return
        }

        // Download the image
        URLSession.shared.dataTask(with: imageUrl) { (data, _, _) in
            if let data = data, let imageFileURL = self.saveImageToDisk(data: data) {
                let attachment = try? UNNotificationAttachment(identifier: "image", url: imageFileURL, options: nil)
                if let attachment = attachment {
                    bestAttemptContent.attachments = [attachment]
                }
            }
            contentHandler(bestAttemptContent)
        }.resume()
    }

    private func saveImageToDisk(data: Data) -> URL? {
        let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        let tempFile = tempDirectory.appendingPathComponent("notification_image.jpg")
        try? data.write(to: tempFile)
        return tempFile
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
