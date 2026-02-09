import Foundation

extension String {
    var decodedHTML: String {
        var result = self

        let entityMap: [String: String] = [
            "quot": "\"",
            "apos": "'",
            "amp": "&",
            "lt": "<",
            "gt": ">",
            "nbsp": " "
        ]

        let pattern = "&(#\\d+|#x[0-9A-Fa-f]+|[a-zA-Z]+);"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return result }

        let matches = regex.matches(in: result, options: [], range: NSRange(result.startIndex..., in: result))
        for match in matches.reversed() {
            guard match.numberOfRanges >= 2,
                  let wholeRange = Range(match.range(at: 0), in: result),
                  let keyRange = Range(match.range(at: 1), in: result) else { continue }

            let key = String(result[keyRange])
            var replacement: String

            if key.hasPrefix("#x") || key.hasPrefix("#X") {
                let hex = String(key.dropFirst(2))
                if let code = Int(hex, radix: 16), let scalar = UnicodeScalar(code) {
                    replacement = String(Character(scalar))
                } else {
                    replacement = String(result[wholeRange])
                }
            } else if key.hasPrefix("#") {
                let num = String(key.dropFirst(1))
                if let code = Int(num), let scalar = UnicodeScalar(code) {
                    replacement = String(Character(scalar))
                } else {
                    replacement = String(result[wholeRange])
                }
            } else {
                replacement = entityMap[key] ?? String(result[wholeRange])
            }

            result.replaceSubrange(wholeRange, with: replacement)
        }

        return result
    }
}
