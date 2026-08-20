//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVRemoteImage
import SVDesignSystem
import Photos
import PhotosUI

public struct iOSProjectDetailView: View {
    private let store: StoreOf<iOSProjectDetailFeature>
    
    public init(store: StoreOf<iOSProjectDetailFeature>) {
        self.store = store
    }
    
    public var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20){
                    AppInfoView(
                        store: store.scope(\.appInfo, action: \.appInfo)
                    )
                    .padding(.horizontal, SVSpacing.screenHorizontal)
                    
                    OverviewView(
                        store: store.scope(\.overview, action: \.overview)
                    )
                    .padding(.horizontal, SVSpacing.screenHorizontal)
                    
                    RoleView(
                        store: store.scope(\.role, action: \.role)
                    )
                    .padding(.horizontal, SVSpacing.screenHorizontal)
                        
                    TechStackView(
                        store: store.scope(\.techStack, action: \.techStack)
                    )
                    .padding(.horizontal, SVSpacing.screenHorizontal)
                    ScreenshotsView(
                        screenSize: size,
                        store: store.scope(\.screenshots, action: \.screenshots)
                    )
                    
                    appDescription
                        .padding(.horizontal, SVSpacing.screenHorizontal)
                }
                .padding(.vertical, SVSpacing.screenVertical)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .toolbar {
            if store.mode == .create || store.mode == .edit {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("", systemImage: "checkmark") {
                        store.send(.saveTapped)
                    }
                    .tint(store.isProjectReadyToAdd ? .blue : .gray.opacity(0.3))
                    
                    if store.mode != .create{
                        Button("", systemImage: "xmark") {
                            store.send(.cancelEditTapped)
                        }
                    }
                }
            }else {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        store.send(.editModeTapped)
                    }
                }
            }
        }
    }
    
    private var appDescription: some View {
        SVSection(title: "Description") {
            Text(
                """
                Yatts Artist is a professional iOS platform built specifically for tattoo artists to manage their complete business and client workflow from a single application. The platform was designed to simplify the operational complexity involved in running a modern tattoo practice, covering artist onboarding, professional profile management, studio and location configuration, portfolio and certification management, availability setup, appointment booking, client consultations, real-time communication, and payment onboarding.

                As the iOS Engineer, I worked on the application end-to-end, contributing to the architecture, core feature development, complex workflow implementation, integrations, performance optimization, and production delivery. The application was built using SwiftUI with a VIPER-based architecture and integrated several Apple and third-party technologies including MapKit, Stripe Connect, Socket.IO, Firebase, and Push Notifications.

                A major part of the platform was the artist profile and portfolio system, which allowed tattoo professionals to create detailed profiles, define their tattoo styles and experience, upload artwork galleries and certifications, and present their work professionally to potential clients. The platform also included studio management capabilities, enabling artists to configure studio information, business details, and locations with integrated map functionality.

                The booking and availability system was one of the core engineering challenges. It required handling artist availability, appointment slots, booking requests, consultation workflows, booking states, and interactions between artists and clients. These interconnected workflows were designed with scalable state handling to ensure that changes across bookings, availability, consultations, and artist activity remained consistent and responsive.

                I also implemented real-time communication capabilities using Socket.IO, enabling artists and clients to communicate through consultation requests, approvals, and live chat. The messaging experience required efficient socket handling, responsive conversation updates, and careful state management to maintain a smooth experience while handling continuously changing real-time data.

                For payments, the application integrated Stripe Connect to support secure artist onboarding and payout-related workflows. The Stripe onboarding flow was designed to guide artists through payment setup while minimizing interruptions and handling the associated account and onboarding states reliably.

                Performance and stability were also major areas of focus. Dashboard and booking data loading was optimized to provide faster access to appointments, requests, and artist activity. Portfolio galleries were improved through efficient image caching, lazy loading, and memory-conscious rendering to reduce loading delays and improve scrolling performance. Real-time chat performance was optimized through efficient socket management and controlled conversation updates, while availability and booking flows were refined through cleaner state management and more responsive UI updates.

                The overall engineering approach focused on building a scalable platform rather than isolated screens. Artist management, portfolios, studios, bookings, consultations, payments, and communication were treated as interconnected systems, requiring careful architecture and workflow design. From initial product planning and UX workflow prototyping through core engineering, optimization, and App Store delivery, the application was developed as a production-ready platform for modern tattoo professionals.

                Yatts Artist represents a complete product engineering experience where the work extended beyond implementing individual UI screens. It involved understanding complex business workflows, designing reliable application states, integrating real-time and payment infrastructure, optimizing performance, and delivering a polished native iOS experience from architecture to App Store.
                """
            )
            .font(.callout)
            .expandable(
                length: 4,
                blurRadius: 0,
                animation: .smooth(duration: 0.15)
            )
        }
    }
}
