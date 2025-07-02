# 🕹️ PCG-Dungeons
This project aims to develop a system for generating dungeons programmatically within the Godot game engine. The dungeons will be created using Procedural Content Generation (PCG) techniques, allowing for a fresh and unique experience each time a user generates a new dungeons

---

## 📂 Project Structure

* `main_scene.tscn` / `main_scene.gd`: Main entry point of the project.
* `selection_scene.tscn` / `selection_scene.gd`: Scene for selecting dungeon elements or generation modes.
* `project.godot`: Project configuration file for Godot.
* `.godot/`: Godot internal cache and editor data.

---

## ✨ Features

* **Mixed-Initiative Editing**: Combine user-driven layout with procedural generation tools.
* **Graph-based Layout**: Generate logical dungeon structures using custom algorithms.
* **2D/3D Assets**: Includes models and fonts for visual customization.
* **User Interface Tools**: Drag-and-drop interface with configurable dungeon parameters.

---

## 🚀 Getting Started

1.  **Install Godot Engine** (version compatible with your `.project.godot` file).
2.  **Open the project**:
    * Launch Godot.
    * Click on "**Import**" and select the `project.godot` file inside `Final_Project_V1.2/`.
3.  **Run the main scene** (`main_scene.tscn`) to start the application.

---

## 🛠️ How It Works

This project generates dungeon layouts through a **graph-replacement algorithm**. The system interprets node connections and replaces them with room templates, ensuring playable and diverse level designs.

The user interface allows manual editing and configuration, making it easy to tailor dungeon complexity, size, and layout style.

---

## 📚 Dependencies

* Godot Engine
* GDScript
* (Optional) External assets/models/fonts (check `.godot/editor/`)
