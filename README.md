# HelloPatient

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Sample Document

```html
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script>
window.addEventListener('load', e => {
    let auth = document.body.querySelector('#auth');
    auth.addEventListener('click',() => {
       AppChannel.postMessage(JSON.stringify({
           method: "auth",
           cb: "Alert.postMessage('Authenticated: %s')"
       }));
    });
    let scan = document.body.querySelector('#scan');
    scan.addEventListener('click',() => {
       AppChannel.postMessage(JSON.stringify({
           method: "scan",
           cb: "Alert.postMessage('Scanned: %s')"
       }));
    });
    Alert.postMessage("Loaded");
});
</script>
<style>
html {
    margin-top: 10ex;
    margin-right: 3ex;
    font-size: 4rem;
}
</style>
</head>
<body>
<button type="button" id="auth">Authenticate</button><br/>
<button type="button" id="scan">Code Scan</button>
</body>
</html>
