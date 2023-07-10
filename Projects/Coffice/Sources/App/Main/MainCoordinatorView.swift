//
//  MainCoordinatorView.swift
//  Cafe
//
//  Created by MinKyeongTae on 2023/05/26.
//  Copyright © 2023 com.cafe. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct MainCoordinatorView: View {
  let store: StoreOf<MainCoordinator>

  var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        TabView {
          NavigationView {
            SearchCoordinatorView(
              store: store.scope(
                state: \.searchState,
                action: MainCoordinator.Action.search
              )
            )
          }
          .tabItem {
            Image(systemName: "house")
            Text("홈")
          }
          NavigationView {
            SavedListCoordinatorView(
              store: store.scope(
                state: \.savedListState,
                action: MainCoordinator.Action.savedList
              )
            )
          }
          .tabItem {
            Image(systemName: "square.and.pencil")
            Text("저장")
          }
          NavigationView {
            MyPageCoordinatorView(
              store: store.scope(
                state: \.myPageState,
                action: MainCoordinator.Action.myPage
              )
            )
          }
          .tabItem {
            Image(systemName: "gear")
            Text("MY")
          }
        }

        IfLetStore(
          store.scope(
            state: \.filterSheetState,
            action: MainCoordinator.Action.filterBottomSheet
          ),
          then: CafeFilterBottomSheetView.init
        )

        IfLetStore(
          store.scope(
            state: \.commonBottomSheetState,
            action: MainCoordinator.Action.commonBottomSheet
          ),
          then: CommonBottomSheetView.init
        )

        IfLetStore(
          store.scope(
            state: \.toastMessageState,
            action: MainCoordinator.Action.toastMessage
          ),
          then: ToastView.init
        )

        IfLetStore(
          store.scope(
            state: \.bubbleMessageState,
            action: MainCoordinator.Action.bubbleMessage
          ),
          then: BubbleMessageView.init
        )
        .onTapGesture {
          viewStore.send(.dismissBubbleMessageView)
        }
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

struct MainCoordinatorView_Previews: PreviewProvider {
  static var previews: some View {
    MainCoordinatorView(
      store: .init(
        initialState: .initialState,
        reducer: MainCoordinator()
      )
    )
  }
}
