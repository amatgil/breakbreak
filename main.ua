# Experimental!
~Block {Pos Size Col}

I ~ "git:https://github.com/Marcos-cat/iris" ~ Color Draw Key T
Catppuccin ~ "./catppuccin.ua"

┌─╴GameState
  |Running
  |Paused
  |Intermission # When you just lost a ball but you have another
  |Lost
└─╴

# Constants
H           ← 800
W           ← 1000
PaddleH     ← 30
PaddleW     ← 200
BallW       ← 10
BallH       ← 10
MoveRate    ← 1/8
BlockColors ← [Catppuccin~Green Catppuccin~Yellow Catppuccin~Rosewater Catppuccin~Lavander Catppuccin~Teal]

# Helpers
StartPaddlePos ← ℂ÷₂W -×2.5PaddleH H
StartBall      ← [˙ℂ0.05 ÷₂ℂH W] # [Vel Pos]
StartBlocks ← [{Catppuccin~Green ℂ100 20 ℂ10 10}
               {Catppuccin~Yellow ℂ100 20 ℂ120 10}
               {Catppuccin~Rosewater ℂ100 20 ℂ300 10}
               {Catppuccin~Lavander ℂ100 20 ℂ500 10}]
StartState ← |0.5 StartPaddlePos StartBall StartBlocks 3 GameState~Running

DrawPaddle            ← I~Draw~Rect Catppuccin~Sapphire ℂPaddleW PaddleH       # ? PaddlePos
DrawBlocks            ← ≡(I~Draw~Rect °{⊙⊙⊙})                                  # ? Blocks
DrawBall              ← I~Draw~Rect Catppuccin~Text ℂBallW BallH ⊣             # ? Ball
DrawLives             ← I~Draw~Text Catppuccin~Text 20 ℂ10 40 ⊂"Lives: " °⋕    # ? Lives
IsBallOutOfXBounds    ← ∨⊃(≤0|≥W) ⊙◌°ℂ ⊣                                       # ? Ball
IsBallOutOfYBounds    ← ≤0 ◌°ℂ ⊣                                               # ? Ball
IsPaddleBallCollision ← I~Collide~Rects ⊓(˜⊂ℂPaddleW PaddleH|˜⊂ℂ BallW BallH⊣) # ? PaddlePos Ball

# Main
I~Open [W H] "Breakbreak"

StartState # Stack <- PaddlePos Ball Blocks Lives GameState
I~Loop!(
  I~Draw~Background Catppuccin~Base
  # Reset all
  ⍥(⋅⋅⋅⋅⋅StartState) Key~Down @R

  # Inputs
  ↥ ℂ0 0 ⍥(-×MoveRate i) Key~Down Key~Arrow @<            # Move left, adjust bounds
  ↧ ℂ(-PaddleW W) H ⍥(+×MoveRate i) Key~Down Key~Arrow @> # Move right, adjust bounds

  ⍣(⊸⊙⊙⊙⊙°GameState~Running
    # Step physics
    ⊙(⍜⊣(↧ℂW H ↥ℂ0 0) \+)

    # Bounds dealing (not through bottom)
    ⍥⊙(⍜⊢⍜°ℂ⊙¯) ◡(∨⊃(IsPaddleBallCollision|⋅IsBallOutOfYBounds))
    ⍥⊙(⍜⊢⍜°ℂ¯) ◡⋅IsBallOutOfXBounds

    ◡⋅(≥H◌°ℂ⊣)
    ⍥(◡⋅⋅⋅=₀
      ⨬(⊓(∘|⍜⊢⋅(ℂ0 0) ⋅StartBall|∘|∘|⋅GameState~Intermission)|⊙⊙⊙⊙⋅GameState~Lost)
    )
  | ⊸⊙⊙⊙⊙°GameState~Intermission
    ⍥(⊓(∘|⋅StartBall|∘|-₁|⋅GameState~Running)) I~Key~Down I~Key~Space
    I~Draw~Text Catppuccin~Text 20 ℂ 10 -₂₀H "Press <SPC> to continue by using a life"
  | ⊸⊙⊙⊙⊙°GameState~Lost
    I~Draw~Text Catppuccin~Text 20 ℂ30 -₂₀÷₂ H "You've lost, press R to reset"
  )

  # Blocks
  # ⊙(⊙⊙[] # Ball Blocks Acc
  #  ⍜:∧(
  #    # Stack <- Block Ball CheckedBlocks
  #    ◡(I~Collide~Rects ⊓(≡°□↙₋₂|⊂ ℂBallH BallW ⊣)) # Collision?
  #    ⨬(⊃(⋅⊙⋅|˜⊂⊙⋅⊙)                                # No collision, leave as checked
  #    | ⊸(⊓⊡₂⊣)                                     # Collision, find direction; don't re-add block
  #      ⨬(⍜⊢⍜°ℂ⊙¯|⍜⊢⍜°ℂ¯)                           # Do the flip in the found direction
  #    )
  #  ))

  # Draw
  ◡⊓(DrawPaddle|DrawBall|DrawBlocks|DrawLives)
)
