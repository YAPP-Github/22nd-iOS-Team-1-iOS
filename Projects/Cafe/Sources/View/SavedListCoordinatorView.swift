//
//  SavedListCoordinatorView.swift
//  Cafe
//
//  Created by MinKyeongTae on 2023/05/29.
//  Copyright © 2023 com.cafe. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct SavedListCoordinatorView: View {
  let store: StoreOf<SavedListCoordinator>

  var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) {
        CaseLet(
          state: /SavedListScreen.State.savedList,
          action: SavedListScreen.Action.savedList,
          then: SavedListView.init
        )
      }
    }
  }
}
