@Builder
export function GesturePageBuilder() {
  GesturePage()
}

@Component
struct GesturePage {
  @State textStatus: string = 'Awaiting 2 Finger Gesture'

  build() {
    NavDestination() {
      Text(this.textStatus)
        .id('GestureText')
        .height('100%')
        .gesture(
          PanGesture({ fingers: 2 })
            .onActionEnd((event: GestureEvent) => {
              this.textStatus = 'Gesture Triggered'
            })
        )
        .textAlign(TextAlign.Center)
        .alignRules(
          { center: { anchor: '__container__', align: VerticalAlign.Center } }
        )
    }
    .hideTitleBar(true)
  }
}