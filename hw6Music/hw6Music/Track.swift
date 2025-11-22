import Foundation

struct Track {
    let title: String
    let artist: String
    let coverImageName: String
    let audioFileName: String

    var fileNameWithoutExtension: String {
        return (audioFileName as NSString).deletingPathExtension
    }
    var fileExtension: String {
        return (audioFileName as NSString).pathExtension
    }
}
