# Technion Pinball FPGA Game

An FPGA-based pinball-style game implemented in SystemVerilog using Quartus.  
The game is displayed on a VGA screen and controlled through keyboard input. It combines classic pinball mechanics with a Technion-themed scoring system: the player collects academic credit points by hitting faculty-themed objects and advances through academic years until completing the degree.

## Project Overview

This project was developed as a final project for the Electrical Engineering Lab 1A course at the Technion.

The game simulates a 2D pinball table with:

- A moving ball affected by gravity and collisions
- Two user-controlled flippers
- A dynamic ball-launching mechanism
- Faculty-themed score objects
- Multiple game stages with increasing difficulty
- Lives, score tracking, win/lose conditions
- VGA graphics and audio feedback

The creative theme of the project is "finishing a degree at the Technion."  
The player aims to collect 160 credit points. Every 40 points represent progress to the next academic year, and reaching 160 points results in victory.

## Main Features

- **VGA-based 2D game display**
  - Static game arena
  - Faculty objects
  - Ball, flippers, score, lives, and game-state indicators

- **Pinball physics**
  - Ballistic ball movement
  - Gravity effect
  - Collision handling with borders, obstacles, flippers, and faculty objects

- **Interactive flippers**
  - Two angular flippers controlled by keyboard input
  - Independent motion for left and right flippers
  - Gradual angular movement while a key is pressed
  - Automatic return after key release
  - Shorter flippers in later stages to increase difficulty

- **Dynamic shooting mechanism**
  - Initial launch state
  - Variable launch behavior
  - Ball-launch path closure mechanism

- **Game controller state machine**
  - Manages all major game states
  - Handles reset, shooting, stage transitions, victory, and failure
  - Controls score and lives
  - Triggers events for audio and visual modules

- **Technion-themed scoring**
  - Faculty objects act as special score targets
  - Score values depend on the current academic year/stage
  - Objects can move or change position after certain events

- **Audio feedback**
  - Different sounds for events such as collisions, launch, failure, and special hits

- **End-game indicators**
  - Visual indication for victory
  - Visual indication for failure

## Game Rules

The player starts with a fixed number of lives and launches the ball into the pinball arena.  
The goal is to keep the ball in play using the flippers and collect score by hitting the faculty objects.

Progression:

| Score Range | Game Stage |
|---|---|
| 0-39 | Year 1 |
| 40-79 | Year 2 |
| 80-119 | Year 3 |
| 120-159 | Year 4 |
| 160+ | Victory |

A life is lost when the ball reaches the bottom of the screen.  
If the player reaches 160 points before losing all lives, the game ends in victory.  
If all lives are lost before reaching the target score, the game ends in failure.

## Controls

Keyboard input is used for user interaction.

| Action | Key |
|---|---|
| Left flipper | `4` |
| Right flipper | `6` |
| Launch ball | Add according to source code |
| Reset game | Add according to source code |

> Note: update this table after checking the final key mapping in the restored Quartus project.

## System Architecture

The project is built from multiple SystemVerilog modules connected through a top-level hierarchy.

Main modules:

| Module | Role |
|---|---|
| `Game_Controller` / `controller_game` | Main game state machine. Controls stages, lives, score, collisions, victory, failure, reset, and event outputs. |
| `BallControlBlock` | Computes ball position and motion according to keyboard input, collisions, gravity, and game-controller signals. |
| `Block_Flipper` / `Flipper` | Generates and animates the two flippers. Uses geometric calculations to draw angular moving lines. |
| `Audio_Controller` | Selects and triggers sounds according to game events. |
| Faculty object modules | Draw faculty-themed objects and generate draw/collision requests. Some objects can move or change position. |
| VGA / Object MUX | Combines drawing requests from all visible objects and sends the correct RGB output to the VGA controller. |
| Shooting mechanism | Handles the initial ball launch and launch-channel behavior. |
| Score and life display | Displays the current score and remaining lives. |
| Win/Loss logo modules | Display visual indicators at the end of the game. |

## Game Controller State Machine

The `controller_game` module is one of the central modules in the project.  
It uses a finite-state machine with the following main states:

- `Idle` - initial state, reset state, or state after losing a life
- `Shooting` - ball launch and launch-speed loading
- `Step1` - first academic year / first difficulty stage
- `Step2` - second academic year / increased difficulty
- `Step3` - third academic year
- `Step4` - fourth academic year
- `End_Game` - final victory or failure state

The controller receives collision signals, keyboard-related signals, score information, and ball-position events. It outputs control signals to the ball, VGA, audio, score, and visual-object modules.

## Flipper Module

The flipper system is implemented using geometric drawing and motion logic.

Each flipper is represented as a line with:

- A fixed pivot point
- A moving endpoint
- A predefined radius
- A changing angle
- A configurable thickness

When the user presses the relevant key, the moving endpoint is updated gradually along a circular path. This creates angular flipper motion around the pivot point. When the key is released, the endpoint gradually returns to its default position.

In later game stages, the flipper length is shortened to make the game more difficult.

## Development and Debugging

The project was developed in stages:

1. Basic VGA and audio interface exploration
2. MVP implementation with a ball, flippers, obstacles, movement, and basic collisions
3. Full game integration with scoring, stages, audio, moving objects, win/loss behavior, and final hierarchy

Signal Tap was used to inspect internal signals, including state transitions in the `controller_game` module. One checked scenario was the transition from Stage 1 to Stage 2 after hitting the Electrical Engineering faculty object and updating the score.

## Resource Usage

The final design had reasonable FPGA resource usage and compiled in under 10 minutes.  
Most of the resource usage was attributed to:

- The `controller_game` module, due to the large number of flip-flops and state/control logic
- Bitmap-related modules that use large two-dimensional vectors

Reported compilation time: approximately **6 minutes and 33 seconds**.

## Repository Structure

```text
.
├── RTL/
│   ├── VGA/
│   │   ├── Project_Top.bdf
│   │   ├── TOP_VGA_DEMO_KBD.bdf
│   │   ├── game_controller.sv
│   │   ├── ScoreCalculator.sv
│   │   ├── Audio_Controller.sv
│   │   ├── Flipper_Block.bdf
│   │   ├── Shooting_Block.bdf
│   │   ├── Faculties_Block.bdf
│   │   ├── Score_Block.bdf
│   │   ├── Life_Block.bdf
│   │   ├── Logos_Block.bdf
│   │   ├── bitmap modules
│   │   ├── object-drawing modules
│   │   └── background modules
│   │
│   ├── AUDIO/
│   │   ├── TOP_AUDIO.bdf
│   │   ├── AUDIO.bdf
│   │   ├── ToneDecoder.sv
│   │   ├── SinTable.sv
│   │   ├── addr_counter.sv
│   │   └── prescaler.sv
│   │
│   ├── KEYBOARD/
│   │   ├── KEYBOARD_INTERFACE.qxp
│   │   ├── random.sv
│   │   ├── simple_up_counter.sv
│   │   └── HexSS.sv
│   │
│   └── Seg7/
│       └── SEG7.sv
│
├── constraints/
│   ├── pin.tcl
│   └── DE10_Standard_Audio.sdc
│
├── *.qip / *.qxp files
├── Quartus project files
└── README.md
```


## How to Open the Project

1. Install Intel Quartus Prime.
2. Restore the `.qar` archive if needed.
3. Open the restored `.qpf` project file in Quartus.
4. Compile the project.
5. Connect the FPGA board to:
   - VGA display
   - Keyboard input
   - Audio output, if used
6. Program the FPGA with the generated `.sof` file.


## Authors

- Safit Levy
- Tal Oved

## Acknowledgments

Developed as part of Electrical Engineering Lab 1A, course 044157, at the Technion - Israel Institute of Technology.

Instructor: Mohammed Naser
