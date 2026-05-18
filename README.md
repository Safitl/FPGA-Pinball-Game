# Technion Pinball FPGA Game

A Technion-themed pinball game implemented on an FPGA using **SystemVerilog** and **Quartus BDF block diagrams**.

The game combines VGA graphics, keyboard control, audio feedback, score tracking, lives, moving flippers, ball movement, collision logic, and win/loss game states. The theme is based on completing a degree at the Technion: the player collects academic credit points by hitting faculty-themed targets, and reaching 160 points represents completing the degree.

---

## Project Summary

This project was developed for the **Electrical Engineering Laboratory 1A** course at the Technion.

The game includes:

- VGA display output
- Keyboard input
- Audio output
- A 2D pinball arena
- A moving ball affected by gravity and collisions
- Two user-controlled flippers
- A dynamic ball-launching mechanism
- Faculty-themed score targets
- Score and life display
- Multiple game stages
- Victory and failure screens

---

## Game Concept

The player launches the ball into the arena and uses the left and right flippers to keep it in play. The objective is to hit faculty objects, gain points, and progress through academic years.

The game is won when the player reaches **160 points**, representing the number of credits needed to complete the degree.

| Score Range | Game Stage |
|---|---|
| 0-39 | Year 1 |
| 40-79 | Year 2 |
| 80-119 | Year 3 |
| 120-159 | Year 4 |
| 160+ | Victory |

A life is lost when the ball reaches the bottom of the screen. If all lives are lost before reaching 160 points, the game ends in failure.

---

## Main Features

### VGA Graphics

The game is displayed on a VGA screen and includes a fixed 2D game arena, ball, flippers, faculty bitmap objects, score, lives, background graphics, and victory/failure logos.

### Keyboard Control

Keyboard input is used to control the game actions.

| Action | Key |
|---|---|
| Left flipper | `4` |
| Right flipper | `6` |
| Launch ball | Verify in source code |
| Reset game | Verify in source code |

### Ball and Collision Logic

The ball moves through the arena according to the game logic and reacts to borders, flippers, faculty objects, obstacles, and bottom-screen fall detection.

### Flipper System

The two flippers are controlled independently. Each flipper is drawn as a line with a fixed pivot point and a moving endpoint. When the player presses the relevant key, the endpoint moves gradually along a circular path, creating angular flipper motion. When the key is released, the flipper returns gradually to its default position.

In later stages, the flippers become shorter to increase the game difficulty.

### Game Controller

The main game logic is implemented in `RTL/VGA/game_controller.sv`.

The controller manages reset behavior, ball launch state, score updates, life updates, stage transitions, collision events, victory/failure conditions, and output signals to VGA, audio, and object modules.

The controller is based on a finite-state machine with the following main states:

- `Idle`
- `Shooting`
- `Step1`
- `Step2`
- `Step3`
- `Step4`
- `End_Game`

### Audio Feedback

The project includes audio modules that generate different sounds for game events such as launch, collisions, failure, and special hits.

---

## Repository Structure

The repository preserves the restored Quartus project structure. Some Quartus/IP files remain in the root directory because Quartus may reference them by relative path. Moving them into another folder may break the project.

```text
.
├── README.md
├── .gitignore
├── Lab1Demo.qpf
├── Lab1Demo.qsf
├── WaveformGC.vwf
├── WaveformGCSim.vwf
│
├── clock_divider.qip
├── clock_divider.sip
├── clock_divider.cmp
├── audio_codec_controller.qxp
├── X_loca.qip
├── X_location.qip
├── Y_location.qip
├── Number_position.qip
├── matrix_top_XY.qip
│
├── constraints/
│   ├── pin.tcl
│   └── DE10_Standard_Audio.sdc
│
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
└── docs/
    ├── final_report.pdf
    └── screenshots/
```

---

## Important Files

| File / Folder | Description |
|---|---|
| `Lab1Demo.qpf` | Main Quartus project file. Open this file in Quartus. |
| `Lab1Demo.qsf` | Quartus settings file, including project assignments. |
| `RTL/VGA/Project_Top.bdf` | Main top-level block diagram of the FPGA design. |
| `RTL/VGA/TOP_VGA_DEMO_KBD.bdf` | VGA and keyboard integration block. |
| `RTL/VGA/game_controller.sv` | Main game-controller finite-state machine. |
| `RTL/VGA/Flipper_Block.bdf` | Flipper subsystem. |
| `RTL/VGA/Shooting_Block.bdf` | Ball-launching subsystem. |
| `RTL/VGA/Faculties_Block.bdf` | Faculty target subsystem. |
| `RTL/VGA/Score_Block.bdf` | Score display subsystem. |
| `RTL/VGA/Life_Block.bdf` | Life display subsystem. |
| `RTL/VGA/Logos_Block.bdf` | Victory and failure logo display subsystem. |
| `RTL/AUDIO/` | Audio synthesis and event-sound logic. |
| `RTL/KEYBOARD/` | Keyboard interface and helper logic. |
| `constraints/` | Pin and timing constraints. |
| `*.qip`, `*.qxp`, `*.sip`, `*.cmp` | Quartus/IP-related files required by the project. |
| `WaveformGC.vwf`, `WaveformGCSim.vwf` | Simulation waveform files. |

---

## How to Open the Project

1. Install Intel Quartus Prime.
2. Clone or download this repository.
3. Open Quartus.
4. Open the project file:

```text
Lab1Demo.qpf
```

5. Verify that all source files are detected.
6. Compile the project.
7. Program the FPGA board using the generated `.sof` file.

---

## GitHub Upload Notes

This repository intentionally keeps several Quartus-generated or IP-related files in the root directory because they may be required for the project to open correctly.

Files that should be kept in the repository:

```text
*.sv
*.bdf
*.qpf
*.qsf
*.qip
*.qxp
*.sip
*.cmp
*.sdc
*.tcl
*.vwf
```

Generated build outputs should not be committed:

```text
db/
incremental_db/
output_files/
*.sof
*.pof
*.rpt
*.summary
*.done
*.qarlog
```

---

## Suggested `.gitignore`

```gitignore
# Quartus generated databases
db/
incremental_db/
greybox_tmp/
.qsys_edit/

# Quartus build/programming outputs
output_files/
*.sof
*.pof
*.rbf
*.jic
*.rpd
*.cdf

# Reports and logs
*.rpt
*.summary
*.smsg
*.done
*.pin
*.sta.rpt
*.fit.rpt
*.asm.rpt
*.map.rpt
*.flow.rpt
*.qarlog

# Temporary / backup files
*.bak
*.orig
*.tmp
*.qws
*.ddb
*.eqn
*.jdi

# Editor / OS files
.vscode/
.DS_Store
Thumbs.db
```

---

## Development Process

The project was built in several stages:

1. Learning and testing the VGA and audio interfaces.
2. Building a minimal playable version with ball movement, flippers, obstacles, and collision behavior.
3. Integrating score, lives, game stages, faculty objects, audio feedback, and end-game screens.
4. Debugging the final hierarchy and validating state transitions.

Signal Tap was used to inspect internal game-controller behavior, including transitions between game stages and score updates.

---

## Resource Usage

The final design had reasonable FPGA resource usage and compiled in under 10 minutes. The reported compilation time was approximately **6 minutes and 33 seconds**.

Most of the resources were used by the main game-controller logic, state machines, flip-flops, and large bitmap modules used for VGA graphics.

---

## Authors

- Safit Levy
- Tal Oved

---

## Acknowledgments

Developed as part of **Electrical Engineering Laboratory 1A**, course **044157**, at the Technion - Israel Institute of Technology.

Instructor: Mohammed Naser
