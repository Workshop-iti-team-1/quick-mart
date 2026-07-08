//
//  OrderStatusBadge.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 06/07/2026.
//

import SwiftUI

// MARK: - Payment Status

enum PaymentStatus : Equatable{
    case paid
    case pending        // COD — cash not yet collected
    case refunded
    case partiallyRefunded
    case voided
    case unknown(String)

    init(rawValue: String) {
        switch rawValue.uppercased() {
        case "PAID":                self = .paid
        case "PENDING":             self = .pending
        case "REFUNDED":            self = .refunded
        case "PARTIALLY_REFUNDED":  self = .partiallyRefunded
        case "VOIDED":              self = .voided
        default:                    self = .unknown(rawValue)
        }
    }

    var label: String {
        switch self {
        case .paid:                return "Paid"
        case .pending:             return "Pending"
        case .refunded:            return "Refunded"
        case .partiallyRefunded:   return "Partially Refunded"
        case .voided:              return "Voided"
        case .unknown(let raw):    return raw.capitalized
        }
    }

    var color: Color {
        switch self {
        case .paid:                return .cyanPrimary
        case .pending:             return .appOrange
        case .refunded:            return .appPurple
        case .partiallyRefunded:   return .appBlue
        case .voided:              return .grayText
        case .unknown:             return .grayText
        }
    }

    var icon: String {
        switch self {
        case .paid:                return "checkmark.circle.fill"
        case .pending:             return "clock.fill"
        case .refunded:            return "arrow.uturn.backward.circle.fill"
        case .partiallyRefunded:   return "arrow.uturn.backward.circle"
        case .voided:              return "xmark.circle.fill"
        case .unknown:             return "questionmark.circle.fill"
        }
    }
}

// MARK: - Fulfillment Status

enum FulfillmentStatus {
    case fulfilled
    case unfulfilled
    case inProgress
    case onHold
    case scheduled
    case partiallyFulfilled
    case unknown(String)

    init(rawValue: String) {
        switch rawValue.uppercased() {
        case "FULFILLED":           self = .fulfilled
        case "UNFULFILLED":         self = .unfulfilled
        case "IN_PROGRESS":         self = .inProgress
        case "ON_HOLD":             self = .onHold
        case "SCHEDULED":           self = .scheduled
        case "PARTIALLY_FULFILLED": self = .partiallyFulfilled
        default:                    self = .unknown(rawValue)
        }
    }

    var label: String {
        switch self {
        case .fulfilled:            return "Delivered"
        case .unfulfilled:          return "Processing"
        case .inProgress:           return "Shipped"
        case .onHold:               return "On Hold"
        case .scheduled:            return "Scheduled"
        case .partiallyFulfilled:   return "Partially Shipped"
        case .unknown(let raw):     return raw.capitalized
        }
    }

    var color: Color {
        switch self {
        case .fulfilled:            return .cyanPrimary
        case .unfulfilled:          return .appOrange
        case .inProgress:           return .appBlue
        case .onHold:               return .appYellow
        case .scheduled:            return .appPurple
        case .partiallyFulfilled:   return .appMerigold
        case .unknown:              return .grayText
        }
    }

    var icon: String {
        switch self {
        case .fulfilled:            return "checkmark.circle.fill"
        case .unfulfilled:          return "clock.fill"
        case .inProgress:           return "shippingbox.fill"
        case .onHold:               return "pause.circle.fill"
        case .scheduled:            return "calendar.circle.fill"
        case .partiallyFulfilled:   return "shippingbox"
        case .unknown:              return "questionmark.circle.fill"
        }
    }
}

// MARK: - Badge View

struct OrderStatusBadge: View {

    enum BadgeType {
        case payment(PaymentStatus)
        case fulfillment(FulfillmentStatus)
    }

    let type: BadgeType

    private var label: String {
        switch type {
        case .payment(let s):     return s.label
        case .fulfillment(let s): return s.label
        }
    }

    private var color: Color {
        switch type {
        case .payment(let s):     return s.color
        case .fulfillment(let s): return s.color
        }
    }

    private var icon: String {
        switch type {
        case .payment(let s):     return s.icon
        case .fulfillment(let s): return s.icon
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .medium))
            Text(label)
                .appTextStyle(.caption, color: color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.12))
        .cornerRadius(6)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        HStack(spacing: 8) {
            OrderStatusBadge(type: .payment(.init(rawValue: "PAID")))
            OrderStatusBadge(type: .payment(.init(rawValue: "PENDING")))
            OrderStatusBadge(type: .payment(.init(rawValue: "REFUNDED")))
        }
        HStack(spacing: 8) {
            OrderStatusBadge(type: .fulfillment(.init(rawValue: "FULFILLED")))
            OrderStatusBadge(type: .fulfillment(.init(rawValue: "UNFULFILLED")))
            OrderStatusBadge(type: .fulfillment(.init(rawValue: "IN_PROGRESS")))
        }
        HStack(spacing: 8) {
            OrderStatusBadge(type: .fulfillment(.init(rawValue: "ON_HOLD")))
            OrderStatusBadge(type: .fulfillment(.init(rawValue: "PARTIALLY_FULFILLED")))
        }
    }
    .padding(16)
    .background(Color.backGround)
}
