//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Roland Lariotte on 17/11/2020.
//

import SwiftUI

struct ProjectsView: View {

  static let openTag: String? = "Open"
  static let closedTag: String? = "Closed"

  @StateObject var viewModel: ViewModel

  @State private var showingSortOrder = false

  init(dataController: DataController,
       showClosedProjects: Bool) {
    let viewModel = ViewModel(dataController: dataController,
                              showClosedProjects: showClosedProjects)
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var projectList: some View {
    List {
      ForEach(viewModel.projects) { project in
        Section(header: ProjectHeaderView(project: project)) {
          ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
            ItemRowView(project: project, item: item)
          }
          .onDelete { offsets in
            viewModel.delete(offsets, from: project)
          }

          if viewModel.showClosedProjects == false {
            Button { withAnimation {
              viewModel.addItems(to: project)
            }} label: {
              Label("Add New Item", systemImage: "plus")
            }
          }
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
  }

  var addProjectToolbarItem: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      if viewModel.showClosedProjects == false {
        Button(action: { withAnimation {
          viewModel.addProject()
        }}) {
          // In iOS 14.3, Voice Over has a glitch that reads the label
          // "Add Project" as "Add" no matter what accessibility label
          // we give this toolbar button when using a Label.
          // As a result, when Voice Over is running, we use a text view
          // for the button instead, forcing a correct reading without
          // losing the original layout.
          if UIAccessibility.isVoiceOverRunning {
            Text("Add Project")
          } else {
            Label("Add Project", systemImage: "plus")
          }
        }
      }
    }
  }

  var sortOrderToolbarItem: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button {
        showingSortOrder.toggle()
      } label: {
        Label("Sort", systemImage: "arrow.up.arrow.down")
      }
    }
  }

  var body: some View {
    NavigationView {
      Group {
        if viewModel.projects.isEmpty {
          Text("There is nothing here right now")
            .foregroundColor(.secondary)
        } else {
          projectList
        }
      }
      .navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
      .toolbar {
        addProjectToolbarItem
        sortOrderToolbarItem
      }
      .actionSheet(isPresented: $showingSortOrder) {
        ActionSheet(title: Text("Sort items"), message: nil, buttons: [
          .default(Text("Optimized")) { viewModel.sortOrder = .optimized },
          .default(Text("Creation Date")) { viewModel.sortOrder = .creationDate},
          .default(Text("Title")) { viewModel.sortOrder = .title }
        ])
      }

      SelectSomethingView()
    }
  }
}

struct ProjectsView_Previews: PreviewProvider {

  static var previews: some View {
    ProjectsView(dataController: DataController.preview,
                 showClosedProjects: false)
  }
}
