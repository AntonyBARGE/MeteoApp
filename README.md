<table>
    <caption>
        <h1 align="center">Application météorologique - BARGE Antony</h1>
    </caption>
    <tr>
        <th scope="col">Page 1 : météo actuelle</th>
        <th scope="col">Page 2 : météo recherchée</th>
    </tr>
    <tr>
        <th scope="col">
            <img src="https://github.com/AntonyBARGE/MeteoApp/blob/main/gif%20page%201.gif" width="50%"/>
        </th>
        <th scope="col">
            <img src="https://github.com/AntonyBARGE/MeteoApp/blob/main/gif%20page%202.gif" width="50%"/>
        </th>
    </tr>
</table>

# Librairies, packages et API utilisés
<h3 align="center">Packages</h3>
    <ul>

        <li>
    
        </li>
        <li>Milk</li>
    </ul>

<h3 align="center">API</h3>

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2

  # for empty api return exceptions
  dartz: ^0.10.1

  # for value equalities
  equatable: ^2.0.5

  # for communication with online API : "Weather Forecast API" from Open-Meteo
  http: ^0.13.5

  # to verify if there is an internet connection
  internet_connection_checker: ^1.0.0+1

  # dateformat and more
  intl: ^0.18.0

  # for customized theme
  flex_color_scheme: ^7.0.0-dev.3

  # for service locator, container and injections
  get_it: ^7.2.0

  # for routing
  auto_route: ^6.0.4

  # for state management
  provider: ^6.0.5

  # for location
  geolocator: ^9.0.2
  geocoding: ^2.1.0

  # for custom navbar (does it respect material 3?)
  circle_nav_bar: ^2.0.1+1



  dev dep 
  # for clean code
  flutter_lints: ^2.0.0

  # for test mocks
  mockito: ^5.4.0

  # to generate mocks from annotations
  build_runner: ^2.3.3

  # to generate routes for auto_route
  auto_route_generator: ^6.0.2

En cas d’utilisation d’APIs ou de librairies non spécifiées, veuillez les citer et
expliquer le choix dans le README du projet.

Localisation de l’utilisateur
- Recherche de lieux (villes, communes, etc…)
- Récupération de la météo en fonction d’une position (latitude,
longitude) et d’un jour. On devrait pouvoir récupérer:
- Les températures de chaque heure de la journée (en fonction
de l’unité par défaut du système)
- La température ressentie
- La vitesse du vent
- Toutes autres informations météorologiques que vous jugez
nécessaires.
Il faudra pour ce faire:
- Implémenter deux pages principales et une barre de navigation (style
NavigationBar de Material 3). Aucun design vous est imposé, juste le
respect du Material 3.
- La première page affichera la météo du jour et la position
actuelle de l’utilisateur.
- La seconde page affichera deux champs (un d’autocomplétion
de lieu et un de sélection du jour) ainsi que la météo en
fonction de ces données.
- Implémenter les tests
- Tests Unitaires des différentes fonctionnalités
- Tests de Widgets des différents composants et interfaces
