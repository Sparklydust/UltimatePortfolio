//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Roland Lariotte on 21/11/2020.
//

import SwiftUI

struct EditProjectView: View {

  @ObservedObject var project: Project

  @EnvironmentObject var dataController: DataController
  @Environment(\.presentationMode) var presentationMode

  @State private var title: String
  @State private var detail: String
  @State private var color: String
  @State private var showingDeleteConfirm = false

  let colorColumns = [
    GridItem(.adaptive(minimum: 44))
  ]

  init(project: Project) {
    self.project = project

    _title = State(wrappedValue: project.projectTitle)
    _detail = State(wrappedValue: project.projectDetail)
    _color = State(wrappedValue: project.projectColor)
  }

  var body: some View {
    Form {
      Section(header: Text("Basic settings")) {
        TextField("Project name", text: $title.onChange(update))
        TextField("Description of this project", text: $detail.onChange(update))
      }

      Section(header: Text("Custom project color")) {
        LazyVGrid(columns: colorColumns) {
          ForEach(Project.colors, id: \.self, content: colorButton)
        }
        .padding(.vertical)
      }

      // swiftlint:disable:next line_length
      Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project entirely.")) {
        Button(project.closed ? "Reopen this project" : "Close this project") {
          project.closed.toggle()
          update()
        }

        Button("delete this project") {
          showingDeleteConfirm.toggle()
        }
        .accentColor(.red)
      }
    }
    .navigationTitle("Edit Project")
    .onDisappear(perform: dataController.save)
    .alert(isPresented: $showingDeleteConfirm) {
      Alert(
        title: Text("Delete project?"),
        message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."), // swiftlint:disable:this line_length
        primaryButton: .default(Text("Delete"), action: delete),
        secondaryButton: .cancel())
    }
  }

  func update() {
    project.title = title
    project.detail = detail
    project.color = color
  }

  func delete() {
    dataController.delete(project)
    presentationMode.wrappedValue.dismiss()
  }

  func colorButton(for item: String) -> some View {
    ZStack {
      Color(item)
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(6)

      if item == color {
        Image(systemName: "checkmark.circle")
          .foregroundColor(.white)
          .font(.largeTitle)
      }
    }
    .onTapGesture {
      color = item
      update()
    }
    .accessibilityElement(children: .ignore)
    .accessibilityAddTraits(
        item == color
            ? [.isButton, .isSelected]
            : .isButton
    )
    .accessibilityLabel(LocalizedStringKey(item))
  }
}

struct EditProjectView_Previews: PreviewProvider {
  static var previews: some View {
    EditProjectView(project: Project.example)
  }
}
