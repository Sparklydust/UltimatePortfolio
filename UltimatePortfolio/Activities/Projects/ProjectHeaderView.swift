//
//  ProjectHeaderView.swift
//  UltimatePortfolio
//
//  Created by Roland Lariotte on 20/11/2020.
//

import SwiftUI

struct ProjectHeaderView: View {

  @ObservedObject var project: Project

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(project.projectTitle)

        ProgressView(value: project.completionAmount)
          .accentColor(Color(project.projectColor))
      }
      Spacer()

      NavigationLink(destination: EditProjectView(project: project)) {
        Image(systemName: "square.and.pencil")
      }
    }
    .padding(.bottom, 10)
    .accessibilityElement(children: .combine)
  }
}

struct ProjectHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    ProjectHeaderView(project: Project.example)
  }
}
