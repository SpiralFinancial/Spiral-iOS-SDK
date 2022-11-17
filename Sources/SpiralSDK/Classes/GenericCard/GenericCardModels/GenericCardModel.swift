//
//  GenericCardModel.swift
//  SpiralBank
//
//  Created by Ron Soffer on 7/26/21.
//  Copyright © 2021 Upnetix. All rights reserved.
//

import Foundation

// swiftlint:disable file_length

enum SpiralGenericCardError: Error {
    case unknownComponentType
}

public enum SpiralGenericCardComponentType: String, Codable {
    case container
    case zContainer = "z_container"
    case scrollContainer = "scroll_container"
    case modal = "modal_container"
    case image
    case text
    case button
    case html
}

public enum SpiralGenericCardContainerAxis: String, Codable {
    case horizontal
    case vertical
    
    var asStackViewAxis: NSLayoutConstraint.Axis {
        return self == .horizontal ? NSLayoutConstraint.Axis.horizontal :
                                     NSLayoutConstraint.Axis.vertical
    }
}

public struct SpiralGenericCardContentPadding: Codable {
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

public enum SpiralGenericCardSnapEdge: String, Codable {
    case left
    case right
    case top
    case bottom
}

public enum SpiralGenericCardContentAlignment: String, Codable {
    case left
    case center
    case right
    case justified
}

public enum SpiralGenericCardContentMode: String, Codable {
    case aspectFit = "aspect_fit"
    case aspectFill = "aspect_fill"
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

public enum SpiralGenericGradientDirection: String, Codable {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
    case topLeftToBottomRight
}

public struct SpiralGenericCardGradient: Codable {
    let direction: SpiralGenericGradientDirection
    let colors: [String]
    let distribution: [Double]?
    
    public init(direction: SpiralGenericGradientDirection, colors: [String], distribution: [Double]? = nil) {
        self.direction = direction
        self.colors = colors
        self.distribution = distribution
    }
}

public enum SpiralGenericCardTextWeight: String, Codable {
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

public protocol SpiralGenericCardComponentContent: Codable {}

public struct GenericCardModel: Codable, Hashable {
    
    let backgroundColor: String?
    let backgroundImage: String?
    let link: String?
    
    let root: SpiralGenericCardComponent
    
    private enum CodingKeys: String, CodingKey {
        case backgroundColor = "background_color"
        case backgroundImage = "background_image"
        case link
        case root
    }
    
    public init(backgroundColor: String? = nil,
         backgroundImage: String? = nil,
         link: String? = nil,
         root: SpiralGenericCardComponent) {
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.link = link
        self.root = root
    }
    
    public static func == (lhs: GenericCardModel, rhs: GenericCardModel) -> Bool {
        return false
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }
}

public class SpiralGenericCardComponent: Codable {
    let type: SpiralGenericCardComponentType
    let backgroundColor: String?
    let backgroundGradient: SpiralGenericCardGradient?
    let alpha: CGFloat?
    let blur: Bool?
    let fixedWidth: CGFloat?
    let fixedHeight: CGFloat?
    let padding: SpiralGenericCardContentPadding?
    let snapToEdges: [SpiralGenericCardSnapEdge]?
    let link: String?
    let links: [String]?
    let content: SpiralGenericCardComponentContent?
    
    private enum CodingKeys: String, CodingKey {
        case type
        case backgroundColor = "background_color"
        case backgroundGradient = "background_gradient"
        case alpha
        case blur
        case fixedWidth = "fixed_width"
        case fixedHeight = "fixed_height"
        case padding
        case snapToEdges = "snap_to_edges"
        case link
        case links
        case content
    }
    
    public init(type: SpiralGenericCardComponentType,
         backgroundColor: String? = nil,
         backgroundGradient: SpiralGenericCardGradient? = nil,
         alpha: CGFloat? = nil,
         blur: Bool? = nil,
         fixedWidth: CGFloat? = nil,
         fixedHeight: CGFloat? = nil,
         padding: SpiralGenericCardContentPadding? = nil,
         snapToEdges: [SpiralGenericCardSnapEdge]? = nil,
         link: String? = nil,
         links: [String]? = nil,
         content: SpiralGenericCardComponentContent?) {
        self.type = type
        self.backgroundColor = backgroundColor
        self.backgroundGradient = backgroundGradient
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
        type = try container.decode(SpiralGenericCardComponentType.self, forKey: .type)
        backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        backgroundGradient = try container.decodeIfPresent(SpiralGenericCardGradient.self, forKey: .backgroundGradient)
        alpha = try container.decodeIfPresent(CGFloat.self, forKey: .alpha)
        blur = try container.decodeIfPresent(Bool.self, forKey: .blur)
        fixedWidth = try container.decodeIfPresent(CGFloat.self, forKey: .fixedWidth)
        fixedHeight = try container.decodeIfPresent(CGFloat.self, forKey: .fixedHeight)
        padding = try container.decodeIfPresent(SpiralGenericCardContentPadding.self, forKey: .padding)
        snapToEdges = try container.decodeIfPresent([SpiralGenericCardSnapEdge].self, forKey: .snapToEdges)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        links = try container.decodeIfPresent([String].self, forKey: .links)

        // Dynamically decode content
        switch type {
        case .container, .modal:
            content = try container.decode(SpiralGenericCardComponentContainer.self, forKey: .content)
        case .zContainer:
            content = try container.decode(SpiralGenericCardZComponentContainer.self, forKey: .content)
        case .scrollContainer:
            content = try container.decode(SpiralGenericCardScrollComponentContainer.self, forKey: .content)
        case .image:
            content = try container.decode(SpiralGenericCardImageComponent.self, forKey: .content)
        case .text:
            content = try container.decode(SpiralGenericCardTextComponent.self, forKey: .content)
        case .button:
            content = try container.decode(SpiralGenericCardButtonComponent.self, forKey: .content)
        case .html:
            content = try container.decode(SpiralGenericCardHtmlComponent.self, forKey: .content)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(padding, forKey: .padding)
        try container.encodeIfPresent(snapToEdges, forKey: .snapToEdges)
        try container.encodeIfPresent(backgroundColor, forKey: .backgroundColor)
        try container.encodeIfPresent(backgroundGradient, forKey: .backgroundGradient)
        try container.encodeIfPresent(alpha, forKey: .alpha)
        try container.encodeIfPresent(blur, forKey: .blur)
        try container.encodeIfPresent(fixedWidth, forKey: .fixedWidth)
        try container.encodeIfPresent(fixedHeight, forKey: .fixedHeight)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(links, forKey: .links)
        switch type {
        case .container, .modal:
            try container.encodeIfPresent(content as? SpiralGenericCardComponentContainer, forKey: .content)
        case .zContainer:
            try container.encodeIfPresent(content as? SpiralGenericCardZComponentContainer, forKey: .content)
        case .scrollContainer:
            try container.encodeIfPresent(content as? SpiralGenericCardScrollComponentContainer, forKey: .content)
        case .image:
            try container.encodeIfPresent(content as? SpiralGenericCardImageComponent, forKey: .content)
        case .text:
            try container.encodeIfPresent(content as? SpiralGenericCardTextComponent, forKey: .content)
        case .button:
            try container.encodeIfPresent(content as? SpiralGenericCardButtonComponent, forKey: .content)
        case .html:
            try container.encodeIfPresent(content as? SpiralGenericCardHtmlComponent, forKey: .content)
        }
    }
}

public class SpiralGenericCardComponentContainer: SpiralGenericCardComponentContent {
    let axis: SpiralGenericCardContainerAxis?
    let children: [SpiralGenericCardComponent]?
    
    private enum CodingKeys: String, CodingKey {
        case axis
        case children
    }
    
    public init(axis: SpiralGenericCardContainerAxis? = nil, children: [SpiralGenericCardComponent]?) {
        self.axis = axis
        self.children = children
    }
}

public class SpiralGenericCardZComponentContainer: SpiralGenericCardComponentContent {
    let children: [SpiralGenericCardComponent]?
    
    private enum CodingKeys: String, CodingKey {
        case children
    }
    
    public init(children: [SpiralGenericCardComponent]?) {
        self.children = children
    }
}

public class SpiralGenericCardScrollComponentContainer: SpiralGenericCardComponentContent {
    let children: [SpiralGenericCardComponent]?
    
    private enum CodingKeys: String, CodingKey {
        case children
    }
    
    public init(children: [SpiralGenericCardComponent]?) {
        self.children = children
    }
}

public class SpiralGenericCardImageComponent: SpiralGenericCardComponentContent {
    let url: String
    let fixedWidth: CGFloat?
    let fixedHeight: CGFloat?
    let aspectRatio: String?
    let contentMode: SpiralGenericCardContentMode?
    
    private enum CodingKeys: String, CodingKey {
        case url
        case fixedWidth = "fixed_width"
        case fixedHeight = "fixed_height"
        case aspectRatio = "aspect_ratio"
        case contentMode = "content_mode"
    }
    
    public init(url: String,
         fixedWidth: CGFloat? = nil,
         fixedHeight: CGFloat? = nil,
         aspectRatio: String? = nil,
         contentMode: SpiralGenericCardContentMode? = nil) {
        self.url = url
        self.fixedWidth = fixedWidth
        self.fixedHeight = fixedHeight
        self.aspectRatio = aspectRatio
        self.contentMode = contentMode
    }
}

public class SpiralGenericCardTextComponent: SpiralGenericCardComponentContent {
    let html: String?
    let text: String?
    let textColor: String?
    let textSize: CGFloat?
    let textWeight: SpiralGenericCardTextWeight?
    let alignment: SpiralGenericCardContentAlignment?
    let lineHeight: CGFloat?
    
    private enum CodingKeys: String, CodingKey {
        case html
        case text
        case textColor = "text_color"
        case textSize = "text_size"
        case textWeight = "text_weight"
        case alignment
        case lineHeight = "line_height"
    }
    
    public init(html: String? = nil,
         text: String? = nil,
         textColor: String? = nil,
         textSize: CGFloat? = nil,
         textWeight: SpiralGenericCardTextWeight? = nil,
         alignment: SpiralGenericCardContentAlignment? = nil,
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

public class SpiralGenericCardButtonComponent: SpiralGenericCardComponentContent {
    let text: String
    let textColor: String?
    let textSize: CGFloat?
    let textWeight: SpiralGenericCardTextWeight?
    let borderColor: String?
    let fixedWidth: CGFloat?
    let fixedHeight: CGFloat?
    
    private enum CodingKeys: String, CodingKey {
        case text
        case textColor = "text_color"
        case textSize = "text_size"
        case textWeight = "text_weight"
        case borderColor = "border_color"
        case fixedWidth = "fixed_width"
        case fixedHeight = "fixed_height"
    }
    
    public init(text: String,
         textColor: String? = nil,
         textSize: CGFloat? = nil,
         textWeight: SpiralGenericCardTextWeight? = nil,
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

public class SpiralGenericCardHtmlComponent: SpiralGenericCardComponentContent {
    let html: String?
    
    private enum CodingKeys: String, CodingKey {
        case html
    }
    
    public init(html: String? = nil) {
        self.html = html
    }
}
