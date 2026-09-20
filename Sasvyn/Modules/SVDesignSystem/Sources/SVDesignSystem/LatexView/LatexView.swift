//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 19/09/26.
//

import SwiftUI
import LaTeXSwiftUI

public struct ResumePreviewView: View {

    private let latex = """
    \\documentclass[11pt,letterpaper]{article}

    \\usepackage[
      top=0.35in,
      bottom=0.35in,
      left=0.4in,
      right=0.4in
    ]{geometry}

    \\usepackage{enumitem}
    \\usepackage{titlesec}
    \\usepackage{parskip}
    \\usepackage{hyperref}
    \\usepackage[T1]{fontenc}
    \\usepackage[utf8]{inputenc}

    \\hypersetup{
      colorlinks=true,
      urlcolor=black,
      linkcolor=black
    }

    \\titleformat{\\section}
      {\\large\\bfseries\\uppercase}
      {}{0em}{}
      [\\titlerule]

    \\titlespacing{\\section}{0pt}{8pt}{4pt}

    \\setlength{\\parindent}{0pt}
    \\setlength{\\parskip}{0pt}

    \\setlist[itemize]{
      leftmargin=1.4em,
      itemsep=2pt,
      parsep=0pt,
      topsep=3pt
    }

    \\begin{document}

    \\begin{center}

    {\\LARGE \\textbf{Vijay Thakur}}\\\\[6pt]

    iOS Engineer\\\\[4pt]

    Swift $\\bullet$ SwiftUI $\\bullet$ UIKit $\\bullet$
    Modular Architecture $\\bullet$ Swift Package Manager\\\\[6pt]

    \\small
    Punjab, India
    \\quad$\\bullet$\\quad
    \\href{mailto:thakurvijay0006@gmail.com}{thakurvijay0006@gmail.com}
    \\quad$\\bullet$\\quad
    \\href{tel:+918146408509}{+91-8146408509}

    \\end{center}

    \\section{Professional Summary}

    Production-focused iOS Engineer with 3+ years of experience
    building and shipping native iOS applications using Swift,
    SwiftUI, and UIKit.

    \\section{Technical Skills}

    \\begin{itemize}

    \\item \\textbf{Programming Languages:} Swift, Dart, TypeScript, JavaScript

    \\item \\textbf{iOS Development:} SwiftUI, UIKit, Foundation, Swift Concurrency, URLSession

    \\item \\textbf{Architecture \\& Design:} TCA, MVVM, Clean Architecture, Modular Architecture, Dependency Injection

    \\item \\textbf{Networking:} REST APIs, Socket.IO, WebSockets, Firebase, JSON

    \\end{itemize}

    \\section{Experience}

    \\textbf{iOS Engineer}
    \\hfill
    \\textit{May 2024 -- Apr 2026}

    \\textbf{Bverse Labs Pvt. Ltd.}
    \\hfill
    Mohali, Punjab

    \\begin{itemize}

    \\item Sole iOS Engineer responsible for end-to-end development,
    architecture decisions, debugging, testing, CI/CD automation,
    and App Store releases.

    \\item Architected modular iOS applications using Swift,
    SwiftUI, UIKit, TCA, and Dependency Injection.

    \\end{itemize}

    \\end{document}
    """
    
    public init(){
        
    }

    public var body: some View {
        LaTeX(latex)
    }
}
