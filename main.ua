# Experimental!
~Block {Pos Size Col}

I ~ "git:https://github.com/Marcos-cat/iris" ~ Color Draw Key T
Catppuccin ~ "./catppuccin.ua"

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

DrawPaddle ← I~Draw~Rect Catppuccin~Sapphire ℂPaddleW PaddleH # ? PaddlePos
DrawBlocks ← ≡(I~Draw~Rect °{⊙⊙⊙})                            # ? Blocks
DrawBall   ← I~Draw~Rect Catppuccin~Text ℂBallW BallH ⊣       # ? Ball

# Main
I~Open [W H] "Breakbreak"

# Stack: PaddlePos Ball Blocks
StartPaddlePos StartBall StartBlocks 10 100 ÷₂PaddleH 10
I~Loop!(
  I~Draw~Background Catppuccin~Base

  # Inputs
  ↥ ℂ0 0 ⍥(-×MoveRate i) Key~Down Key~Arrow @<            # Move left, adjust bounds
  ↧ ℂ(-PaddleW W) H ⍥(+×MoveRate i) Key~Down Key~Arrow @> # Move right, adjust bounds

  # Step physics
  ⊙(⍜⊣(↧ℂW H ↥ℂ0 0) \+)

  # Flip ball vel if colliding with paddle
  ⍥(⊙⍜⊢⍜°ℂ⊙¯) ◡(I~Collide~Rects⊓(˜⊂ ℂPaddleW PaddleH|˜⊂ℂ BallW BallH⊣))

  # Draw
  ◡⊓(DrawPaddle|DrawBall?|DrawBlocks)
)
