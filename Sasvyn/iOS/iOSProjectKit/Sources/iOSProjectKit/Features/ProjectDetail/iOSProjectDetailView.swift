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

public struct iOSProjectDetailView: View {
    public let store: StoreOf<iOSProjectDetailFeature>
    
    public init(store: StoreOf<iOSProjectDetailFeature>) {
        self.store = store
    }
    
    public var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20){
                    appInfo
                    overview
                    techStack
                    screenshotsSlider(screenSize: size)
                    appDescription
                }
                .padding()
            }
        }
    }
    
    private var appInfo: some View {
        HStack(spacing: 12) {
            SVRemoteImage(url: .init(string: "https://is1-ssl.mzstatic.com/image/thumb/Video221/v4/af/d5/53/afd553a2-196d-f6ef-ddac-dfc12cbcb788/1e89e771bf7935ff7ecef7c34d1440e0_Preview_Image_Intermediate_nonvideo_sdr_448319311_2726657810.png/632x632bb.webp"), side: 100, shape: .rect(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Youtube")
                    .font(.title2.bold())
                Text("Videos, Music and Live Streams")
                    .font(.subheadline)
                    .foregroundStyle(Color(.systemGray))
                
                Button("App Store") {
                    
                }
                .font(.caption.bold())
                .buttonStyle(.borderedProminent)
                .padding(.top, 6)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func screenshotsSlider(screenSize: CGSize)->some View {
        SVSection(title: "Preview") {
            let screenshotWidth = screenSize.width * 0.60
            let screenshotHeight = screenshotWidth * 19.5 / 9
            ScrollView(.horizontal) {
                LazyHStack(spacing: 12) {
                    ForEach(1...10, id: \.self) { _ in
                        SVRemoteImage(
                            url: .init(string: "https://cdn.sanity.io/images/te8jbj37/production/512d955a5eadf923ba3645fcdb249d4f57f741f9-1172x2390.png"),
                            size: .init(width: screenshotWidth, height: screenshotHeight),
                            shape: .rect(cornerRadius: 15, style: .continuous)
                        )
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            .scrollTargetBehavior(.viewAligned)
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
    
    private var techStack: some View {
        SVSection(title: "Tech Stack") {
            ChipLayoutUI(alignment: .leading, spacing: 8) {
                ForEach(["SwiftUI", "MVVM", "StoreKit", "Socket.IO", "Firebase"], id: \.self) { tech in
                    Text(tech)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6), in: .capsule)
                }
            }
        }
    }
    
    private var overview: some View {
        SVSection(title: "Overview") {
            Text("Yatts Artist is a professional tattoo artist platform designed to help artists manage their complete workflow in one place. Artists can onboard, build their profiles, manage studios and locations, showcase artwork portfolios, configure availability, complete Stripe onboarding, handle bookings and appointments, and communicate with clients through real-time chat and consultation workflows.")
                .font(.callout)
                .expandable(
                    length: 2,
                    blurRadius: 0,
                    animation: .smooth(duration: 0.15)
                )
        }
    }
}

#Preview {
    NavigationStack{
        iOSProjectDetailView(store: .init(initialState: iOSProjectDetailFeature.State(), reducer: {
            iOSProjectDetailFeature()
        }))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "chevron.backward"){}
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "square.and.arrow.up"){}
            }
        }
    }
    .preferredColorScheme(.dark)
}

extension View {
    @ViewBuilder
    public func expandable(
        length: Int,
        moreText: String = "...More",
        blurRadius: CGFloat = 2,
        animation: Animation
    ) -> some View {
        self
            .modifier(
                ExpandableTextModifier(
                    length: length,
                    moreText: moreText,
                    blurRadius: blurRadius,
                    animation: animation
                )
            )
    }
}

extension View {
    @ViewBuilder
    fileprivate func optionalClip(blurRadius: CGFloat)-> some View {
        if blurRadius.isZero {
            self
                .clipped()
        }else {
            self
        }
    }
}

fileprivate struct ExpandableTextModifier: ViewModifier {
    var length: Int
    var moreText: String
    var blurRadius: CGFloat
    var animation: Animation
    
    @State private var limitedSize: CGSize = .zero
    @State private var fullSize: CGSize = .zero
    @State private var animatedProgress: CGFloat = .zero
    @State private var isEnabled: Bool = true
    func body(content: Content) -> some View {
        content
            .lineLimit(length)
            .opacity(0)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: { newValue in
                limitedSize = newValue
            }
            .frame(height: isExpanded ? fullSize.height : nil)
            .overlay {
                GeometryReader {
                    let contentSize = $0.size
                    content
                        .textRenderer(
                            TruncationTextRenderer(
                                length: length,
                                moreText: moreText,
                                blurRadius: blurRadius,
                                progress: animatedProgress
                            )
                        )
                        .fixedSize(horizontal: false, vertical: true)
                        .onGeometryChange(for: CGSize.self) {
                            $0.size
                        } action: { newValue in
                            fullSize = newValue
                        }
                        .frame(
                            width: contentSize.width,
                            height: contentSize.height,
                            alignment: isExpanded ? .leading : .topLeading
                        )
                }
            }
            .optionalClip(blurRadius: blurRadius)
            .contentShape(.rect)
            .onTapGesture {
                isEnabled.toggle()
            }
            .onChange(of: isEnabled) { oldValue, newValue in
                withAnimation(animation) {
                    animatedProgress = !newValue ? 1 : 0
                }
            }
            .onAppear {
                animatedProgress = !isEnabled ? 1 : 0
            }
        
    }
    
    var isExpanded: Bool {
        animatedProgress == 1
    }
    
}

@Animatable
fileprivate struct TruncationTextRenderer: TextRenderer {
    @AnimatableIgnored var length: Int
    @AnimatableIgnored var moreText: String
    var blurRadius: CGFloat
    var progress: CGFloat
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        for (index, line) in layout.enumerated() {
            var copyContext = ctx
            if (index == length - 1){
                drawMoreTextAtEnd(line: line, context: &copyContext)
            }else {
                if index < length  || blurRadius.isZero{
                    copyContext.draw(line)
                }else {
                    drawLinesWithBlurEffect(index: index, layout: layout, context: &copyContext)
                }
            }
        }
    }
    
    /// Applies a progressive blur and opacity effect to lines beyond the truncation limit.
    ///
    /// - Parameters:
    ///   - index: The current line index.
    ///   - layout: The full text layout.
    ///   - context: The graphics context used for rendering.
    ///
    /// - Discussion:
    /// Each line fades in and sharpens as `progress` approaches 1,
    /// creating a smooth expansion animation.
    func drawLinesWithBlurEffect(index: Int, layout: Text.Layout, context: inout GraphicsContext){
        let line = layout[index]
        let lineIndex = Double(index - length)
        let totalExtraLines = Double(layout.count - length)
        
        let lineStartProgress = lineIndex / max(1, totalExtraLines)
        let lineEndProgress = (lineIndex + 1) / max(1, totalExtraLines)
        
        let lineProgress = max(0, min(1, (progress - lineStartProgress) / (lineEndProgress - lineStartProgress)))
        context.opacity = lineProgress
        context.addFilter(.blur(radius: blurRadius - (blurRadius * lineProgress)))
        context.draw(line)
    }
    
    /// Draws the trailing “more” text at the end of the last visible line.
    ///
    /// - Parameters:
    ///   - line: The last visible line.
    ///   - context: The graphics context used for rendering.
    ///
    /// - Discussion:
    /// This method replaces the end of the last visible line with
    /// a partially faded original text and overlays the `moreText`.
    ///
    /// The transition is animated using `progress`, blending between
    /// truncated and full states.
    func drawMoreTextAtEnd(line: Text.Layout.Element, context: inout GraphicsContext){
        let runs = line.flatMap { $0 }
        let runsCount = runs.count
        let textCount = moreText.count
        
        for index in 0..<max(runsCount - textCount, 0){
            let run = runs[index]
            context.draw(run)
        }
        
        for index in max(runsCount - textCount, 0)..<runsCount {
            let run = runs[index]
            context.opacity = progress
            context.draw(run)
        }
        
        let textRunIndex = max(runsCount - textCount, 0)
        guard !runs.isEmpty else { return }
        let run = runs[textRunIndex]
        let typography = run.typographicBounds
        let fontSize: CGFloat = typography.ascent
        let font: UIFont = UIFont.systemFont(ofSize: fontSize)
        let spacing: CGFloat = NSString(string: moreText).size(withAttributes: [
            .font: font
        ]).width / 2
        let swiftUIText = Text(moreText)
            .font(Font(font))
            .foregroundStyle(.gray)
        let origin = CGPoint(
            x: typography.rect.minX + spacing,
            y: typography.rect.midY
        )
        context.opacity = 1 - progress
        context.draw(swiftUIText, at: origin )
    }
    
}
