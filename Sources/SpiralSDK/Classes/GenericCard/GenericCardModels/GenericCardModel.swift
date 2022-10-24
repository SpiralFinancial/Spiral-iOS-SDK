//
//  GenericCardModel.swift
//  SpiralBank
//
//  Created by Ron Soffer on 7/26/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation

// swiftlint:disable file_length

enum GenericCardError: Error {
    case unknownComponentType
}

public enum GenericCardComponentType: String, Codable {
    case container
    case zContainer = "z_container"
    case scrollContainer = "scroll_container"
    case modal = "modal_container"
    case header
    case image
    case text
    case button
    case html
}

public enum GenericCardContainerAxis: String, Codable {
    case horizontal
    case vertical
    
    var asStackViewAxis: NSLayoutConstraint.Axis {
        return self == .horizontal ? NSLayoutConstraint.Axis.horizontal :
                                     NSLayoutConstraint.Axis.vertical
    }
}

public struct GenericCardContentPadding: Codable {
    let left: CGFloat
    let right: CGFloat
    let top: CGFloat
    let bottom: CGFloat
    
    public init(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
}

public enum GenericCardSnapEdge: String, Codable {
    case left
    case right
    case top
    case bottom
}

public enum GenericCardContentAlignment: String, Codable {
    case left
    case center
    case right
    case justified
}

public enum GenericCardContentMode: String, Codable {
    case aspectFit
    case aspectFill
    case left
    case center
    case right
    
    var asViewContentMode: UIView.ContentMode {
        switch self {
        case .aspectFit: return UIView.ContentMode.scaleAspectFit
        case .aspectFill: return UIView.ContentMode.scaleAspectFill
        case .left: return UIView.ContentMode.left
        case .center: return UIView.ContentMode.center
        case .right: return UIView.ContentMode.right
        }
    }
}

public enum GenericCardTextWeight: String, Codable {
    case ultrathin
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black
    case signature
    case greycliffRegular
    case greycliffBold
}

public protocol GenericCardComponentContent: Codable {}

public struct GenericCardModel: Codable {
    let backgroundColor: String?
    let backgroundImage: String?
    let link: String?
    
    let root: GenericCardComponent
    
    private enum CodingKeys: String, CodingKey {
        case backgroundColor
        case backgroundImage
        case link
        case root
    }
    
    public init(backgroundColor: String? = nil,
         backgroundImage: String? = nil,
         link: String? = nil,
         root: GenericCardComponent) {
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.link = link
        self.root = root
    }
}

public class GenericCardComponent: Codable {
    let type: GenericCardComponentType
    let backgroundColor: String?
    let alpha: CGFloat?
    let blur: Bool?
    let fixedWidth: CGFloat?
    let fixedHeight: CGFloat?
    let padding: GenericCardContentPadding?
    let snapToEdges: [GenericCardSnapEdge]?
    let link: String?
    let links: [String]?
    let content: GenericCardComponentContent?
    
    private enum CodingKeys: String, CodingKey {
        case type
        case backgroundColor
        case alpha
        case blur
        case fixedWidth
        case fixedHeight
        case padding
        case snapToEdges
        case link
        case links
        case content
    }
    
    public init(type: GenericCardComponentType,
         backgroundColor: String? = nil,
         alpha: CGFloat? = nil,
         blur: Bool? = nil,
         fixedWidth: CGFloat? = nil,
         fixedHeight: CGFloat? = nil,
         padding: GenericCardContentPadding? = nil,
         snapToEdges: [GenericCardSnapEdge]? = nil,
         link: String? = nil,
         links: [String]? = nil,
         content: GenericCardComponentContent?) {
        self.type = type
        self.backgroundColor = backgroundColor
        self.alpha = alpha
        self.blur = blur
        self.fixedWidth = fixedWidth
        self.fixedHeight = fixedHeight
        self.padding = padding
        self.snapToEdges = snapToEdges
        self.link = link
        self.links = links
        self.content = content
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(GenericCardComponentType.self, forKey: .type)
        backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        alpha = try container.decodeIfPresent(CGFloat.self, forKey: .alpha)
        blur = try container.decodeIfPresent(Bool.self, forKey: .blur)
        fixedWidth = try container.decodeIfPresent(CGFloat.self, forKey: .fixedWidth)
        fixedHeight = try container.decodeIfPresent(CGFloat.self, forKey: .fixedHeight)
        padding = try container.decodeIfPresent(GenericCardContentPadding.self, forKey: .padding)
        snapToEdges = try container.decodeIfPresent([GenericCardSnapEdge].self, forKey: .snapToEdges)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        links = try container.decodeIfPresent([String].self, forKey: .links)

        // Dynamically decode content
        switch type {
        case .container, .modal:
            content = try container.decode(GenericCardComponentContainer.self, forKey: .content)
        case .zContainer:
            content = try container.decode(GenericCardZComponentContainer.self, forKey: .content)
        case .scrollContainer:
            content = try container.decode(GenericCardScrollComponentContainer.self, forKey: .content)
        case .header:
            content = try container.decode(GenericCardHeaderComponent.self, forKey: .content)
        case .image:
            content = try container.decode(GenericCardImageComponent.self, forKey: .content)
        case .text:
            content = try container.decode(GenericCardTextComponent.self, forKey: .content)
        case .button:
            content = try container.decode(GenericCardButtonComponent.self, forKey: .content)
        case .html:
            content = try container.decode(GenericCardHtmlComponent.self, forKey: .content)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(padding, forKey: .padding)
        try container.encodeIfPresent(snapToEdges, forKey: .snapToEdges)
        try container.encodeIfPresent(backgroundColor, forKey: .backgroundColor)
        try container.encodeIfPresent(alpha, forKey: .alpha)
        try container.encodeIfPresent(blur, forKey: .blur)
        try container.encodeIfPresent(fixedWidth, forKey: .fixedWidth)
        try container.encodeIfPresent(fixedHeight, forKey: .fixedHeight)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(links, forKey: .links)
        switch type {
        case .container, .modal:
            try container.encodeIfPresent(content as? GenericCardComponentContainer, forKey: .content)
        case .zContainer:
            try container.encodeIfPresent(content as? GenericCardZComponentContainer, forKey: .content)
        case .scrollContainer:
            try container.encodeIfPresent(content as? GenericCardScrollComponentContainer, forKey: .content)
        case .header:
            try container.encodeIfPresent(content as? GenericCardHeaderComponent, forKey: .content)
        case .image:
            try container.encodeIfPresent(content as? GenericCardImageComponent, forKey: .content)
        case .text:
            try container.encodeIfPresent(content as? GenericCardTextComponent, forKey: .content)
        case .button:
            try container.encodeIfPresent(content as? GenericCardButtonComponent, forKey: .content)
        case .html:
            try container.encodeIfPresent(content as? GenericCardHtmlComponent, forKey: .content)
        }
    }
}

public class GenericCardComponentContainer: GenericCardComponentContent {
    let axis: GenericCardContainerAxis?
    let children: [GenericCardComponent]?
    
    private enum CodingKeys: String, CodingKey {
        case axis
        case children
    }
    
    public init(axis: GenericCardContainerAxis? = nil, children: [GenericCardComponent]?) {
        self.axis = axis
        self.children = children
    }
}

public class GenericCardZComponentContainer: GenericCardComponentContent {
    let children: [GenericCardComponent]?
    
    private enum CodingKeys: String, CodingKey {
        case children
    }
    
    public init(children: [GenericCardComponent]?) {
        self.children = children
    }
}

public class GenericCardScrollComponentContainer: GenericCardComponentContent {
    let children: [GenericCardComponent]?
    
    private enum CodingKeys: String, CodingKey {
        case children
    }
    
    public init(children: [GenericCardComponent]?) {
        self.children = children
    }
}

public class GenericCardHeaderComponent: GenericCardComponentContent {
    let icon: String?
    let title: String
    let titleColor: String?
    let subtitle: String
    let subtitleColor: String?
    
    private enum CodingKeys: String, CodingKey {
        case icon
        case title
        case titleColor
        case subtitle
        case subtitleColor
    }
    
    public init(icon: String?, title: String, titleColor: String? = nil, subtitle: String, subtitleColor: String? = nil) {
        self.icon = icon
        self.title = title
        self.titleColor = titleColor
        self.subtitle = subtitle
        self.subtitleColor = subtitleColor
    }
}

public class GenericCardImageComponent: GenericCardComponentContent {
    let url: String
    let fixedWidth: CGFloat?
    let fixedHeight: CGFloat?
    let aspectRatio: String?
    let contentMode: GenericCardContentMode?
    
    private enum CodingKeys: String, CodingKey {
        case url
        case fixedWidth
        case fixedHeight
        case aspectRatio
        case contentMode
    }
    
    public init(url: String,
         fixedWidth: CGFloat? = nil,
         fixedHeight: CGFloat? = nil,
         aspectRatio: String? = nil,
         contentMode: GenericCardContentMode? = nil) {
        self.url = url
        self.fixedWidth = fixedWidth
        self.fixedHeight = fixedHeight
        self.aspectRatio = aspectRatio
        self.contentMode = contentMode
    }
}

public class GenericCardTextComponent: GenericCardComponentContent {
    let html: String?
    let text: String?
    let textColor: String?
    let textSize: CGFloat?
    let textWeight: GenericCardTextWeight?
    let alignment: GenericCardContentAlignment?
    let lineHeight: CGFloat?
    
    private enum CodingKeys: String, CodingKey {
        case html
        case text
        case textColor
        case textSize
        case textWeight
        case alignment
        case lineHeight
    }
    
    public init(html: String? = nil,
         text: String? = nil,
         textColor: String? = nil,
         textSize: CGFloat? = nil,
         textWeight: GenericCardTextWeight? = nil,
         alignment: GenericCardContentAlignment? = nil,
         lineHeight: CGFloat? = nil) {
        self.html = html
        self.text = text
        self.textColor = textColor
        self.textSize = textSize
        self.textWeight = textWeight
        self.alignment = alignment
        self.lineHeight = lineHeight
    }
}

public class GenericCardButtonComponent: GenericCardComponentContent {
    let text: String
    let textColor: String?
    let textSize: CGFloat?
    let textWeight: GenericCardTextWeight?
    let borderColor: String?
    let fixedWidth: CGFloat?
    let fixedHeight: CGFloat?
    
    private enum CodingKeys: String, CodingKey {
        case text
        case textColor
        case textSize
        case textWeight
        case borderColor
        case fixedWidth
        case fixedHeight
    }
    
    public init(text: String,
         textColor: String? = nil,
         textSize: CGFloat? = nil,
         textWeight: GenericCardTextWeight? = nil,
         borderColor: String? = nil,
         fixedWidth: CGFloat? = nil,
         fixedHeight: CGFloat? = nil) {
        self.text = text
        self.textColor = textColor
        self.textSize = textSize
        self.textWeight = textWeight
        self.borderColor = borderColor
        self.fixedWidth = fixedWidth
        self.fixedHeight = fixedHeight
    }
}

public class GenericCardHtmlComponent: GenericCardComponentContent {
    let html: String?
    
    private enum CodingKeys: String, CodingKey {
        case html
    }
    
    public init(html: String? = nil) {
        self.html = html
    }
}
