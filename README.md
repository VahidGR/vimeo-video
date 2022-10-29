# vimeo-video

## Security
There are a number of keys that need to be stored inside the project for APIs to function properly. For example API end point token. They are saved in a secure file named VimeoConfig.xcconfig and in a normal case, it should be included inside .gitignore file, but since this is an assessment project and for the reviewers to test the functionallity of the app it is needed, I have included this file to be on this git repository.



## Architecture
I have used MVVM architecture per requested. Any API call is inside ViewModels and they pass data to their paired ViewController, to properly pass information to their Views.

Our MVVM implentation uses a folder structure as such:

- Util -> Utilitarian objects: single responsible
- App
- Coordination -> contains coordinator and steps for app to navigate through modules without them having to know about each other
- Module
  - Controller
  - ViewModel
  - View
- Preferences -> user preferences, authentication status
- Helper -> extensions to scale up the existing objects
- Service
  - APIs -> base URL, custom init, extended URLs 
  - Webservice -> single responsible and generic objects to make API calls and load images. Loaded images are stored to be reused, to minimise user network usage
- Model



## Reactive programming
I have implemented few SDKs from Rx category. Any observable behaviour is done with a Rx object. To name a few examples, You can see this pattern inside ViewModels to observe fetched data and data binding inside ViewControllers to use that data to update UI, for instance UICollectionView instance on ListViewController; or isLoading BehaviourRelay instance and activity extenstion for UIViewController.

Some extensions for RxSwift made our custom components reactive compatible. You can find out more in Helper->Rx folder.



## Player
VimeoPlayer instance is a custom View class that contains a AVPlayer and uses its layer to present video, and a custom control object named VimeoPlayerControlView to implement custom video control interactions; such as play/pause, mute/sound-on and fullscreen/minimise.

Our vimeo player uses Rx SDKs to observe user behaviour such as gestures and video completion status, to act upon gestures and reset video on an ending event.

An optimization is made for videos to better prepare and for AVPlayer to load video faster. It sets AVPlayer's automaticallyWaitsToMinimizeStalling = false

To explain why, a qoute from Apple developer documentation
> A Boolean value that indicates whether the player should automatically delay playback in order to minimize stalling.

It's an optimization for user experience, where video player component loads faster so that user can see our whole UI in a faster manner.
