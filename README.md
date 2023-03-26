# Biomechanical Analysis Interaction System

A 3D educational experience designed to engage students while informing them about ACL injury risk and joint health.

## Style

<!-- TODO: Figure out better formatting for this section -->

This project strictly follows [Godot's style guide][1]. The file structure is grounded in the [project organization reference][2] and inspired by [this article by Shantnu Tiwari][3]. The principles are described below:

-   All folders and files are `snake_case`.
-   All folders which categorize their contents should be plural.
    -   `scenes, actors, characters`
-   All files should be in the folder which categorizes them.
    -   `scenes > actors > characters > x_bot.tscn`
-   If there are two or more directly related files, they should be placed in their own sub-folder.
    -   `scenes > actors > characters > player > player.gd, player.tscn`

<!-- ? Is this useful at all? The subfolders seem pretty self explanatory -->

| Top-level folder | Contents                                                         |
| ---------------- | ---------------------------------------------------------------- |
| addons           | 3rd party files, such as plugins <br> Custom engine/editor files |
| assets           | Raw materials used to build scenes                               |
| scenes           | All scenes (.tscn files) and their related scripts               |
| src              | All code that isn't tied to a particular scene                   |
| test             | All test code                                                    |

<!-- Links are here for cleanliness above -->

[1]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
[2]: https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
[3]: https://new.pythonforengineers.com/blog/how-to-structure-your-godot-project-so-you-dont-get-confused/
