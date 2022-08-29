
DropdownContainer is used to provide a dropdown for its child.

## Features

* There is no limit for the dropdown widget and child widget.

* The current focus will not been transfered.

For example, user can keep inputting in a TextField while the dropdown containing complex widgets is shown/hidden/changed according to the user inputs.

![alt text](https://raw.githubusercontent.com/tu-x-com/dropdown-container-flutter/master/example/images/textfield_with_dropdown.png)

## Getting started

What you need is to provide [child], [controller] and [dropdownBuilder] for this container. 

[child] will be built as a normal widget, while [dropdownBuilder] will be called when dropdown is open.
[controller] is used to open or close the dropdown.

## Usage

Please refer to [/example] for a full example.

```dart
final TextEditingController _textController;
final DropdownContainerController _dropdownController;

void buid(BuildContext context) {
    return DropdownContainer(
      controller: _dropdownController,
      dropdownBuilder: (context) => Row(children: [
        Expanded(child: Image.network('http://image-url')),
        Expanded(
            child: Column(
                children: _textController.text.characters
                    .map((e) => ListTile(title: Text(e), onTap: () {}))
                    .toList())),
      ]),
      child: TextField(
          controller: _textController,
          onChanged: (e) {
            if (e.isNotEmpty) {
              _dropdownController.open();
            } else {
              _dropdownController.close();
            }
          }),
    );
}
```

## Simple API Manual
```dart
// DropdropContainer options
Widget child;                               // The child widget which wants a dropdown
WidgetBuilder dropdownBuilder;              // Build the widget displayed in dropdown
DropdownContainerController controller;     // Control the dropdown
bool barrierDismissable;                    // Dismiss the dropdown when user taps the outside of dropdown if the value is true

// DropdownContainerController members
void open();                                // Open the dropdown
void close();                               // Close the dropdown
bool opening;                               // Check if the dropdown is opening
void update();                              // Update the widget forcely. It will be used when widget built by builder can not rerender itself automatically.
void dispose();                             // Dispose the controller
```


## Additional information

