@Builder
export function FormPageBuilder() {
   FormPage()
}

@Component
struct FormPage {
   fields: Array<string> = [
      'Name',
      'Surname',
      'Mail',
      'Password',
      'Phone'
   ]

   build() {
      NavDestination() {
         List() {
            ForEach(this.fields, (item: string) => {
               ListItem() {
                  TextInput({
                     placeholder: item
                  })
                     .id(item)
                     .height(50)
                     .width('100%')
                     .margin({ bottom: 20 })

               }
               .padding({left: 15, right: 15})
            }, (item: string, _) => item)
         }
         .height('100%')
         .width('100%')
         .padding({top: 40})
      }
   .hideTitleBar(true)
   }
}