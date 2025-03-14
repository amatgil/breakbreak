# Experimental!
I ~ "git:https://github.com/Marcos-cat/iris" ~ Color Draw Key T
Catppuccin ~ "./catppuccin.ua"

# Constants
H        ← 800
W        ← 1000
PaddleH  ← 30
PaddleW  ← 200
MoveRate ← 1/8

# Helpers

# UpdtPosX! ← ⊙◌°⊟ ⊙⊸+ # NewPos ? BoundsOp BoundsPlane Delta OldPos

# UpdtPosX!max 0 10 ℂ100 200

I~Open [W H] "Breakbreak"

ℂ÷₂W -×2.5PaddleH H # paddlePos
I~Loop!(
  I~Draw~Background Catppuccin~Base
  ↥ ℂ0 0 ⍥(-×MoveRate i) Key~Down Key~Arrow @<
  ↧ ℂ(-PaddleW W) H ⍥(+×MoveRate i) Key~Down Key~Arrow @>
  ⊸I~Draw~Rect Catppuccin~Sapphire ℂPaddleW PaddleH
)
