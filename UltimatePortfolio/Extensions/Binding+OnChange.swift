//
//  Binding+OnChange.swift
//  UltimatePortfolio
//
//  Created by Roland Lariotte on 20/11/2020.
//

import SwiftUI

extension Binding {

  func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
    Binding(
      get: { self.wrappedValue },
      set: { newValue in
        self.wrappedValue = newValue
        handler()
      }
    )
  }
}
