# Note Hub
### note hub is a notes application that allows user to write textual notes their notes and save them in the cloud.


![Firebase](https://img.shields.io/badge/firebase-a08021?style=for-the-badge&logo=firebase&logoColor=ffcd34) ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white) ![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)

[![Open Source Love svg1](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![saythanks](https://img.shields.io/badge/say-thanks-ff69b4.svg)](https://saythanks.io/to/apdo60311)

## Features

1. **Create Notes:** Users can quickly create new notes with a simple interface.
2. **Edit Notes:** Easily edit existing notes by adding or updating note's content.
3. **Delete Notes:** Users can remove any note with a button click.
4. **Search Functionality:** Find specific notes quickly using the search feature.
5. **User Authentication:** users can create accounts to save their notes.
6. **Customization Options**: The application support dark and light themes and note settings with backgrounds and colors.

## Technologies Used
1. [Flutter](https://flutter.dev/)
2. [Firebase](https://firebase.google.com/)

## Dependencies
  1. **[flutter_bloc](https://pub.dev/packages/flutter_bloc)**
  2. **[image_picker](https://pub.dev/packages/image_picker)**
  3. **[equatable](https://pub.dev/packages/equatable)**
  4. **[bloc](https://pub.dev/packages/bloc)**
  5. **[hexcolor](https://pub.dev/packages/hexcolor)**
  6. **[connectivity_plus](https://pub.dev/packages/hexcolor)**
  7. **[conditional_builder_null_safety](https://pub.dev/packages/conditional_builder_null_safety)**
  8. **[lottie](https://pub.dev/packages/lottie)**
  9. **[permission_handler](https://pub.dev/packages/permisson_handler)**
  10. **[cached_network_image](https://pub.dev/packages/cached_network_image)**
  11. **[pdf](https://pub.dev/packages/pdf)**
  12. **[path_provider](https://pub.dev/packages/path_provider)**
  13. **[open_filex](https://pub.dev/packages/open_filex)**
  14. **[share_plus](https://pub.dev/packages/shared_plus)**
  15. **[shared_preferences](https://pub.dev/packages/shared_preferences)**
  16. **firebase** 
        1. **[firebase_core](https://pub.dev/packages/firebase_core)** 
        2. **[firebase_auth](https://pub.dev/packages/firebase_auth)**
        3. **[cloud_firestore](https://pub.dev/packages/cloud_firestore)**
        4. **[firebase_storage](https://pub.dev/packages/firebase_storage)**
  
## Installation

to start use this project you have to install flutter and dart first.

**1.clone the repository**
```sh
git clone https://github.com/apdo60311/note_hub.git
```
**2. Open project folder in visual studio code**
```sh
cd note_hub
code .
```
**3. Install dependencies**
```sh
flutter pub get
```
**4. Link the project with firbase**

**5. Run project**
```sh
flutter run
```
## Project structure

note_hub/<br>
┣ android/&nbsp;&nbsp;&nbsp;&nbsp; `contains android native codes and configurations`<br>
┣assets/<br>
┃ ┣ animations/&nbsp;&nbsp;&nbsp;&nbsp;`contains lottie json files and gif files`<br>
┃ ┗ images/<br>
┣ios/&nbsp;&nbsp;&nbsp;&nbsp;`contains ios native codes and configurations`<br>
┣ lib/<br>
┃ ┣ app/<br>
┃ ┃ ┗ main_app.dart&nbsp;&nbsp;&nbsp;&nbsp;`contains application main class which contains the material app `<br>
┃┣ bloc/&nbsp;&nbsp;&nbsp;&nbsp;`contains all bloc folders and observers`<br>
┃ ┃ ┣ bloc folders<br>
┃ ┃ ┣ bloc_observer.dart<br>
┃ ┃ ┗ note_modification_state.dart<br>
┃ ┣ config/&nbsp;&nbsp;&nbsp;&nbsp;`contains shared preferences keys & constants & themes`<br>
┃ ┃ ┣ constants/<br>
┃ ┃ ┣ routes_manger/<br>
┃ ┃ ┗ themes/<br>
┃ ┣ data/&nbsp;&nbsp;&nbsp;&nbsp;`data access layer resposible for dealing with firebase`<br>
┃ ┃ ┣ data_sources/<br>
┃ ┃ ┣ models/<br>
┃ ┃ ┗ repositories/<br>
┃ ┣ presentation/&nbsp;&nbsp;&nbsp;&nbsp;`view layer`<br>
┃ ┃ ┣ screens/<br>
┃ ┃ ┗ widgets/<br>
┃ ┣ utils/<br>
┃ ┃ ┣ cache_helper.dart<br>
┃ ┃ ┣ image_picker.dart<br>
┃ ┃ ┣ media_query_extension.dart<br>
┃ ┃ ┣ note_shimmer_effect.dart<br>
┃ ┃ ┣ pdf_handler.dart<br>
┃ ┃ ┣ shared_assets.dart<br>
┃ ┃ ┣ shared_colors.dart<br>
┃ ┃ ┗ shared_methods.dart<br>
┃ ┣ firebase_options.dart<br>
┃ ┗ main.dart<br>
┣test/<br>
┗pubspec.yaml<br>


## Screeshots

<p float="left">
  <img src="./readme-images/image1.png" width="100" />
  <img src="./readme-images/image2.png" width="100" />
  <img src="./readme-images/image3.png" width="100" />
  <img src="./readme-images/image4.png" width="100" />
  <img src="./readme-images/image5.png" width="100" />
  <img src="./readme-images/image6.png" width="100" />
  <img src="./readme-images/image7.png" width="100" />
  <img src="./readme-images/image8.png" width="100" />
  <img src="./readme-images/image9.png" width="100" />
</p>

## License
This project is licensed under the [MIT](https://opensource.org/license/MIT) License.
