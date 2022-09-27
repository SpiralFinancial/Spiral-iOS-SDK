# SpiralSDK

The Spiral SDK is used to open up as a modal in your application. Through the modal, end-users can select a non-profit, select a donation amount / frequency, and submit their donation.

## Usage

The Spiral iOS SDK's main interface is a `UIViewController` that you can integrate into your app as you would any `UIViewController`, e.g. presented as a modal, or used with a `UINavigationController`. Additionally, you can implement the `SpiralDelegate` protocol to receive events throughout the `SpiralViewController`'s lifecycle.

### Installation

The Spiral iOS SDK is available via [Swift Package Manager](https://swift.org/package-manager/) and [CocoaPods](https://cocoapods.org/).

#### Swift Package Manager
Add `https://github.com/spiral-ios/spiral-ios-sdk` as a package dependency.

#### CocoaPods
To install the SDK with CocoaPods, add `SpiralSDK` as one of your target dependencies in your Podfile:

```ruby
use_frameworks!

target 'MyApp' do
    pod 'SpiralSDK'
end
```

Please be sure to run `pod update` and use `pod install --repo-update` to ensure you have the most recent version of the SDK installed.

### Spiral Token

To initialize the `SpiralViewController`, a short-lived Spiral token will need to be generated first. Your server can generate the Spiral token by sending a POST request to the `/v1/spiral_tokens` endpoint with details about the donation update. Your mobile app should fetch the token from your server. DO NOT ever send this request from the client side and publicly expose your api_secret.

The spiral token returned is valid for 15 minutes, after which it expires and can no longer be used to initialize the `SpiralViewController`. The expiration time is returned as a unix timestamp.

### SpiralViewController

The SpiralViewController is a `UIViewController` that you can integrate into your app's flow like so:

```swift
import SpiralSDK

let spiralVC = SpiralViewController(token: spiralToken, delegate: self)
self.present(spiralVC!, animated: true)
```

With the `SpiralViewController`, end-users can select a non-profit, select a donation amount / frequency, and submit their donation. Throughout the authorization process, events will be emitted to the `onEvent` callback. Upon a successful authorization, the `onSuccess` callback will be called. `onExit` will be called when it is time to close the dialog, and you should remove the SpiralSpiral component from your view hierarchy.

## SpiralDelegate

The `SpiralDelegate` protocol is set up such that every event goes through the required `onEvent(name: event:)` handler, and optional convenience methods are provided for the `.exit`, `.success`, `.login`, and `.error` events. Note that the `onEvent(name: event:)` handler will still be called alongside the convenience methods.   

### `onEvent(name: SpiralEventType, event: SpiralEventPayload)`

Callback whenever a user interacts with the modal (e.g. logs in, or initiates a switch). See the [events section](https://getspiral.stoplight.io/docs/api/docs/guides/Spiral.md#events) of the Spiral documentation.

### `onExit(_ error: SpiralError?)`

Optional callback whenever a user exits the modal either explicitly or if an error occurred that crashed the modal. Error codes can be seen [here](https://getspiral.stoplight.io/docs/api/docs/guides/Spiral.md#errors-1).

### `onSuccess(_ result: SpiralSuccessPayload)`

Optional callback whenever a user completes a Spiral flow successfully. Note: This is simply a front end callback only. If a user begins a job, closes the app, and the job completes successfully this callback will not be called.

### `onLogin(_ result: SpiralLoginPayload)`

Optional callback for when a user logs in successfully.

### `onError(_ error: SpiralError)`

Optional callback for when an error occurs.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. Then, you'll need to set up an environment variable with your api secret. 

1. `cp env-vars.example.sh env-vars.sh` 
2. Add your API secret to the newly created file. 
3. `source ./env-vars.sh`

Note that setting up the API secret this way is only for demo purposes. In your app, you should fetch the Spiral token from your server, and you should never include your API secret in your app (compiled or otherwise).

## Tests

There are unit tests, and UI tests included in the example project. The unit tests are associated with the SpiralSDK_Tests scheme, and the UI tests are associated SpiralSDK_UITests scheme. 

To run the UI tests in AWS Device Farm, you will need to configure `env-vars.sh`, and `Example/Matchfile`.


## Dev Workflow Commands

 ### Make Feature

 The starting point for any dev work being done should be a JIRA ticket. JIRA has automation rules that will handle moving TKTs into the right status, as long as the TKT number is in the branch name.

 To handle this for you, we have a `make feature` command that you'll want to use when starting development. From any branch, simply run `make feature` to get started.
 This will ask for a few things:

 1. **JIRA Ticket Numbers**: enter the JIRA ticket number that you're working on (includes project abbreviation and number, i.e. `INT-1643`). This will ask for multiple TKT numbers, if it's just one TKT then press enter when it asks for another one.
 2. **Name**: A very brief name for the branch, i.e. `paycom-login`.

 A new feature branch will then be created with the tkt numbers and name provided.

## Author

[Spiral](https://spiral.us)

## License

SpiralSDK is available under the MIT license. See the LICENSE file for more info.
