# TissueTMDD 1.1.1

## Bug fixes and minor improvements

- Fixed a bug where comparing simulation would lead to empty plot.

# TissueTMDD 1.1.0

## New Features

- Updated all dependencies to latest version. Including {ospsuite}. Thus the app can now run on Linux.
- Add a Dockerfile to create a docker image of the app.
- Add a github action that builds docker image and send to ESQlabs container registry.

## Bug fixes and minor improvements

- Improve time filtering reactivity.


# TissueTMDD 1.0.0

🎉 First stable release of the app !

## Bug fixes and minor improvements

- Available time units are now Hours and Days (#38)
- All inputs invalidates the simulation when changed (#37)
- All compared simulations are now displayed (#39),
- Results are now correctly reset between two simulations with custom settings (#40),


# TissueTMDD 0.2.2

## Bug fixes and minor improvements

* Fix unit conversion between user's input and model units (#36)
* Default dose is now 1 mg/kg
* Now display the application version in the header (#26)

# TissueTMDD 0.2.1

## New Features

* User can now choose the frequency for repeated dosing

## Bug fixes and minor improvements

* User can now switch Time axis between minutes and days,
* `Molecular Weight` input is now in kDa,
* Remove `Hydrodynamic Radius` field

# TissueTMDD 0.2.0

## New Features

* Latest research version of the PK-Sim model,
* New model inputs in the GUI,
* User can now select the target expression tissue to simulate,
* User can now choose between single or repeated drug dose simulations,
* Now uses simulationBatches to improve app performances

## Bug fixes and minor improvements

* New order of Inputs,
* Tooltips to help user using the app,
* Settings export is more reliable,
* Better plot themes

# TissueTMDD 0.1.1

## New Features

* Plot's time range can filtered in the plot option sidebar

## Bug fixes and minor improvements

* Imported settings are automatically selected in the preset input
* Use `bs4Dash::toast` instead of native shiny notifications
* When comparison is deactivated, reset the comparison select input
* New notification when settings are exported to json file
  
# TissueTMDD 0.1.0

First release of the app (experimental)

# TissueTMDD 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
