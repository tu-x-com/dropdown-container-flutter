
DropdownContainer is used to provide a dropdown for its child.

## Features

There is no limit for the dropdown widget and child widget.

For example, a TextField can combined with a dropdown which content is Row and Column

![alt text](https://raw.githubusercontent.com/tutucloud/dropdown-container-flutter/master/example/images/textfield_with_dropdown.png)

## Getting started

What you need is to provide [child], [controller] and [dropdownBuilder] for this container. 

[child] will be built as a normal widget, while [dropdownBuilder] will be called when dropdown is open.
[controller] is used to open or close the dropdown.

## Usage

There are some examples in the [/examples] directory of the repository.

```dart
final TextEditingController _textController;
final DropdownContainerController _dropdownController;

void buid(BuildContext context) {
    return DropdownContainer(
        controller: _dropdownController,
        dropdownBuilder: (context) => Row(children:[
            Expanded(child:Image.network('http://image-url')),
            Expanded(Column(children:_textController.text.map((e)=>ListTile(title:Text(e),onTap:(){})))),
        ]),
        child: TextField(controller: _textController, onChanged((e) {
            if ( e.isNotEmpty ) {
                _dropdownController.open();
            } else {
                _dropdownController.close();
            }
        })),
    );
}
```

## Additional information

