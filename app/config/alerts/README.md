# AppSnackbar

The ```AppSnackbar``` can show a ```SnackBar```

## Example

```dart
Injector.findSingleton<CustomSnackbar>().show(
    (context) => Snackbars.error(
        context,
        text: '',
    ),
);
```

# AppDialog

The ```AppDialog``` can show an ```AlertDialog```

## Example

```dart
Injector.findSingleton<CustomDialog>().confirm(
    dialog: (context) => Dialogs.confirm(
        context,
        message: '',
        confirmText: '',
        cancelText: '',
    ),
);
```