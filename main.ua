# Experimental!

I ~ "git:https://github.com/Marcos-cat/iris" ~ Color Draw Key T
Catppuccin ~ "./catppuccin.ua"
┌─╴Status
  |Running
  |Paused
  |Intermission # When you just lost a ball but you have another, that lil pause
  |Lost
└─╴

# Constants
H       ← 800
W       ← 1000
PaddleH ← 30
PaddleW ← 200
BallW   ← 10
BallH   ← 10
PadVel  ← ×i 1/8
BlockColors ← [Catppuccin~Green
               Catppuccin~Yellow
               Catppuccin~Rosewater
               Catppuccin~Lavander
               Catppuccin~Teal]

# Definitions
~Ball [Vel Pos]
~St {
  Paddle ← ℂ÷₂W -×2.5PaddleH H
  Ball ← Ball ˙ℂ0.05 ÷₂ℂH W
  Blocks
  Lives ← 3
  Status ← Status~Running
}

# Helpers

StartPaddlePos ← ℂ÷₂W -×2.5PaddleH H
StartBall      ← Ball ˙ℂ0.05 ÷₂ℂH W
StartBlocks ← [{Catppuccin~Green ℂ100 20 ℂ10 10}
               {Catppuccin~Yellow ℂ100 20 ℂ120 10}
               {Catppuccin~Rosewater ℂ100 20 ℂ300 10}
               {Catppuccin~Lavander ℂ100 20 ℂ500 10}]
StartState ← |0 St StartBlocks

DrawPaddle            ← I~Draw~Rect Catppuccin~Sapphire ℂPaddleW PaddleH       # ? PaddlePos
DrawBlocks            ← ≡(I~Draw~Rect °{⊙⊙⊙})                                  # ? Blocks
DrawBall              ← I~Draw~Rect Catppuccin~Text ℂBallW BallH ⊣             # ? Ball
DrawLives             ← I~Draw~Text Catppuccin~Text 20 ℂ10 40 ⊂"Lives: " °⋕    # ? Lives
IsPaddleBallCollision ← I~Collide~Rects ⊓(˜⊂ℂPaddleW PaddleH|˜⊂ℂ BallW BallH⊣) # ? PaddlePos Ball

# Main
I~Open [W H] "Breakbreak"

StartState # Stack <- State == {PaddlePos Ball Blocks Lives Status}
I~Loop!(
  I~Draw~Background Catppuccin~Base
  ⍥(⋅StartState) Key~Down @R # Reset all keybind

  # Inputs
  ⍥⍜St~Paddle(↥ ℂ0 0 -PadVel) Key~Down Key~Arrow @<            # Move left, adjust to bounds
  ⍥⍜St~Paddle(↧ ℂ(-PaddleW W) H +PadVel) Key~Down Key~Arrow @> # Move right, adjust to bounds

  ⍣(⊸(°Status~Running St~Status)
    ⍜(St~Ball|⍜⊣(↧ℂW H ↥ℂ0 0) \+) # Advance ball

    ⍥⍜(St~Ball|⍜⊢⍜°ℂ⊙¯) ⊸(∨⊃(≤0◌°ℂ⊣ St~Ball|IsPaddleBallCollision ⊃(St~Paddle|St~Ball)))
    ⍥⍜(St~Ball|⍜⊢⍜°ℂ¯) ⊸(∨⊃(≤0|≥W) ⊙◌°ℂ ⊣ St~Ball)

    ⊸(≥H◌°ℂ⊣ St~Ball)
    ⍥(⊸(=₀St~Lives)
      ⨬(°⊸St~Ball ⍜⊢⋅(ℂ0 0) StartBall
        °⊸St~Status Status~Intermission
      | °⊸St~Status Status~Lost)
    )
  | ⊸(°Status~Intermission St~Status)
    I~Key~Down I~Key~Space
    ⍥(°⊸St~Ball StartBall
      °⊸St~Status Status~Running
      ⍜St~Lives-₁
    )
    I~Draw~Text Catppuccin~Text 20 ℂ 10 -₂₀H "Press <SPC> to continue by using a life"
  | ⊸(°Status~Lost St~Status)
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
  ⊸⊃(
    DrawPaddle St~Paddle
  | DrawBall St~Ball
  | DrawBlocks St~Blocks
  | DrawLives St~Lives)
)
