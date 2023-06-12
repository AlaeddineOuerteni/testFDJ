//
//  UIView+Utils.swift
//  TestFDJ
//
//  Created by Alaeddine Ouertani on 12/06/2023.
//

import UIKit

extension UIView {
    /// Attach all edges of the view to another view.
    ///
    /// This method will automatically turn off translation of autoresizing mask into constraints
    ///
    /// - Parameters:
    ///   - to: the view to attach the current view to (default superview)
    ///   - edgeConstraints: the constraints to be used for the edges of the view
    /// - Returns: the list of created constraints (already activated)
    func attachEdges(to view: UIView? = nil, edgeConstraints: EdgeConstraints = .zero) {
        guard superview != nil else {
            fatalError(
                "You are trying to attach edges of the view \(self)"
                    + " without a superview. Please add it to a view before"
            )
        }

        translatesAutoresizingMaskIntoConstraints = false
        let view = view ?? superview! // swiftlint:disable:this force_unwrapping

        var constraints = [NSLayoutConstraint]()

        if let leading = edgeConstraints.leading {
            constraints.append(
                leadingAnchor.constraint(
                    equalTo: leading.constrainable(from: view).leadingAnchor,
                    constant: leading.constant
                )
            )
        }
        if let trailing = edgeConstraints.trailing {
            constraints.append(
                trailingAnchor.constraint(
                    equalTo: trailing.constrainable(from: view).trailingAnchor,
                    constant: -trailing.constant
                )
            )
        }
        if let top = edgeConstraints.top {
            constraints.append(
                topAnchor.constraint(
                    equalTo: top.constrainable(from: view).topAnchor,
                    constant: top.constant
                )
            )
        }
        if let bottom = edgeConstraints.bottom {
            constraints.append(
                bottomAnchor.constraint(
                    equalTo: bottom.constrainable(from: view).bottomAnchor,
                    constant: -bottom.constant
                )
            )
        }

        NSLayoutConstraint.activate(constraints)
    }

    /// Attach the center of the view to another view.
    ///
    /// This method will automatically turn off translation of autoresizing mask into constraints
    ///
    /// - Parameters:
    ///   - to: the view to attach the current view to (default superview)
    ///   - offset: offset to use on x and y (default .zero)
    /// - Returns: the list of created constraints (already activated)
    func attachCenter(to view: UIView? = nil, offset: CGPoint = .zero) {
        guard superview != nil else {
            fatalError(
                "You are trying to attach the center of the view \(self)"
                    + " without a superview. Please add it to a view before"
            )
        }

        translatesAutoresizingMaskIntoConstraints = false
        let view = view ?? superview! // swiftlint:disable:this force_unwrapping

        let constraints = [
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x),
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

/// Constraints for the edges of a view
struct EdgeConstraints {
    /// Guide constraint for top edge
    let top: GuideConstraint?
    /// Guide constraint for leading edge
    let leading: GuideConstraint?
    /// Guide constraint for bottom edge
    let bottom: GuideConstraint?
    /// Guide constraint for trailing edge
    let trailing: GuideConstraint?

    /// Create constraints for the edges of a view
    /// - Parameters:
    ///   - top: Guide constraint for top edge
    ///   - leading: Guide constraint for leading edge
    ///   - bottom: Guide constraint for bottom edge
    ///   - trailing: Guide constraint for trailing edge
    init(
        top: GuideConstraint?,
        leading: GuideConstraint?,
        bottom: GuideConstraint?,
        trailing: GuideConstraint?
    ) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }

    /// Default constraints, zero constants to the view's anchors
    static let zero = EdgeConstraints(
        top: .default(0),
        leading: .default(0),
        bottom: .default(0),
        trailing: .default(0)
    )

    /// Add constraints for all edges to the view's anchors
    /// - Parameter constant: the constant to use for all edges
    /// - Returns: the edge constraints object
    static func `default`(_ constant: CGFloat) -> EdgeConstraints {
        let constraints = EdgeConstraints(
            top: .default(constant),
            leading: .default(constant),
            bottom: .default(constant),
            trailing: .default(constant)
        )
        return constraints
    }

    /// Add constraints for all edges to the view's safe area layout guide
    /// - Parameter constant: the constant to use for all edges
    /// - Returns: the edge constraints object
    static func safeArea(_ constant: CGFloat) -> EdgeConstraints {
        let constraints = EdgeConstraints(
            top: .safeArea(constant),
            leading: .safeArea(constant),
            bottom: .safeArea(constant),
            trailing: .safeArea(constant)
        )
        return constraints
    }

    /// Add constraints for all edges to the view's readable content guide
    /// - Parameter constant: the constant to use for all edges
    /// - Returns: the edge constraints object
    static func readable(_ constant: CGFloat) -> EdgeConstraints {
        let constraints = EdgeConstraints(
            top: .readable(constant),
            leading: .readable(constant),
            bottom: .readable(constant),
            trailing: .readable(constant)
        )
        return constraints
    }

    /// Add constraints for all horizontal edges to the view's readable content guide
    /// and add constraints for vertical edges to the view's anchors
    /// - Parameters:
    ///   - horizontalConstant: the constant to use for horizontal edges on safeArea
    ///   - verticalConstant: the constant to use for vertical edges on safeArea
    /// - Returns: the edge constraints object
    static func horizontalReadable(horizontalConstant: CGFloat, verticalConstant: CGFloat) -> EdgeConstraints {
        let constraints = EdgeConstraints(
            top: .default(verticalConstant),
            leading: .readable(horizontalConstant),
            bottom: .default(verticalConstant),
            trailing: .readable(horizontalConstant)
        )
        return constraints
    }
}

/// Constraints from a layout guide
enum GuideConstraint {
    /// Constrains to the guides of the view
    case `default`(CGFloat)
    /// Constrains to the view's safe area layout guide
    case safeArea(CGFloat)
    /// Constrains to the view's readable content guide
    case readable(CGFloat)

    /// The constant for this constraint
    var constant: CGFloat {
        switch self {
        case let .default(defaultConstant):
            return defaultConstant
        case let .safeArea(safeAreaConstant):
            return safeAreaConstant
        case let .readable(readableConstant):
            return readableConstant
        }
    }

    /// The edge constrainable applicable for this guide constraint
    /// - Parameter view: the view from where to draw the constrainable
    /// - Returns: the edge constrainable
    fileprivate func constrainable(from view: UIView) -> EdgeConstrainable {
        switch self {
        case .default:
            return view
        case .readable:
            return view.readableContentGuide
        case .safeArea:
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide
            } else {
                return view
            }
        }
    }
}

/// Convienience protocol for objects that have edge anchors
protocol EdgeConstrainable {
    /// Top edge anchor
    var topAnchor: NSLayoutYAxisAnchor { get }
    /// Bottom edge anchor
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    /// Leading edge anchor
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    /// Trailing edge anchor
    var trailingAnchor: NSLayoutXAxisAnchor { get }
}

extension UIView: EdgeConstrainable {}
extension UILayoutGuide: EdgeConstrainable {}
