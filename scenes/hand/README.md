# Creating a new Scene
When making a new top-level scene using this template folder...
1) Rename the `_template` folder to the desired scene name
2) Within the Godot UI, right-click the renamed folder
3) Click `+ Create New -> Scene..`
4) Enter the relevant scene info (i.e. name) within the create scene modal


Organize all content relevant to a scene in the following folders:

## Resources
All relevant assets for the given scene. This can include (but not limited to):
* Images
* Fonts
* Music Files
* Godot-Created Resources (i.e. for UI options)


## Scenes
Need to split up this scene into smaller scene components? Create a copy of the `_template` scene folder and stick it in here! :] Then follow the same instructions for setting up that scene as well (Yes, this is meant to be recursive).


## Scripts
Split up code logic here. Common examples of what you might want to make a separate scripts:
* A file for `signal` related code relevant to this Scene, i.e.:
  * `signal(s)` this Scene can emit
  * `signal(s)` this Scene will subscribe/react to
* A file for Input Handling (in conjunction with the InputMap)
* A file for Instantiating/setting up child Scenes

Try to limit attaching scripts to child Nodes within this Scene. Chances are, you're better off splitting that child Node into a separate scene component and encapsulating the script logic within that scene instead! :]
