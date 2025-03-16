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
H ← 800
W ← 1000

PadH ← 30
PadW ← 200

BallW ← 10
BallH ← 10

BlockH   ← 20
BlockW   ← 65
BlockGap ← 10
BlockPad ← 20
MarginH  ← 10
MarginW  ← 30

BMaxVar   ← 50 # Maximum Variation of Block Width
NumBlocks ← 10 # Per line
NumRows   ← 6  # How many lines
PadVel    ← ×i 1/1
BlockColors ← [Catppuccin~Green
               Catppuccin~Yellow
               Catppuccin~Rosewater
               Catppuccin~Lavander
               Catppuccin~Teal]
# Definitions
~Ball [Vel Pos]
~Block {Color Size Pos}
~St {
  Pad ← ℂ÷₂W -×2.5PadH H
  Ball ← Ball ˙ℂ0.5 ÷₂ℂH W
  Blocks
  Lives ← 3
  Status ← Status~Running
}

# Helpers

# StartBlocks ← [{Catppuccin~Green ℂ100 20 ℂ10 10}
#               {Catppuccin~Yellow ℂ100 20 ℂ120 10}
#               {Catppuccin~Rosewater ℂ100 20 ℂ300 10}
#               {Catppuccin~Lavander ℂ100 20 ℂ500 10}]

# ?
BlockXPositions ← ↧W↥0 ≡(+×BMaxVar-0.5⚂) ×(-MarginW W) ÷⟜⇡ # XPositions ? NumBlocks
BlockPositions  ← ≡ℂ BlockXPositions                       # Positions ? NumBlocks YPos
BlockDimensions ← ≡˜ℂ BlockH⊂⊃⊢⧈- BlockXPositions          # Dimensions ? NumBlocks

# ? NumRows
StartBlocks ← (
  +MarginH ×(+BlockGap BlockH)⇡
  ♭₋₁≡(≡⊂⊃(BlockDimensions|BlockPositions) NumBlocks)
  ≡(⊂ □Catppuccin~Green)
  # ⊂≡⊃(BlockDimensions NumBlocks|BlockPositions NumBlocks)
)

StartState ← |0 St StartBlocks 4

DrawPad            ← I~Draw~Rect Catppuccin~Sapphire ℂPadW PadH          # ? PadPos
DrawBlocks         ← ≡(I~Draw~Rect °{⊙⊙⊙})                               # ? Blocks
DrawBall           ← I~Draw~Rect Catppuccin~Text ℂBallW BallH ⊣          # ? Ball
DrawLives          ← I~Draw~Text Catppuccin~Text 20 ℂ10 40 ⊂"Lives: " °⋕ # ? Lives
IsPadBallCollision ← I~Collide~Rects ⊓(˜⊂ℂPadW PadH|˜⊂ℂ BallW BallH⊣)    # ? PadPos Ball

# Main
I~Open [W H] "Breakbreak"

StartState # Stack <- State == {PadPos Ball Blocks Lives Status}
I~Loop!(
  I~Draw~Background Catppuccin~Base
  ⍥(⋅StartState) Key~Down @R # Reset all keybind

  # Inputs
  ⍥⍜St~Pad(↥ 0 -PadVel) Key~Down Key~Arrow @<            # Move left, adjust to bounds
  ⍥⍜St~Pad(↧ ℂ(-PadW W) H +PadVel) Key~Down Key~Arrow @> # Move right, adjust to bounds

  ⍣(⊸(°Status~Running St~Status)
    ⍜(St~Ball|⍜⊣(↧ℂW H ↥0) \+) # Advance ball

    ⍥⍜(St~Ball|⍜⊢⍜°ℂ⊙¯) ⊸(∨⊃(≤0◌°ℂ⊣ St~Ball|IsPadBallCollision ⊃(St~Pad|St~Ball)))
    ⍥⍜(St~Ball|⍜⊢⍜°ℂ¯) ⊸(∨⊃(≤0|≥ -BallW W) ⊙◌°ℂ ⊣ St~Ball)

    ⊸(≥H◌°ℂ⊣ St~Ball)
    ⍥(⊸(=₀St~Lives)
      ⨬(°⊸St~Ball ⍜⊢⋅0 St~Ball StartState
        °⊸St~Status Status~Intermission
      | °⊸St~Status Status~Lost)
    )
  | ⊸(°Status~Intermission St~Status)
    I~Key~Down I~Key~Space
    ⍥(°⊸St~Ball (St~Ball StartState)
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
    DrawPad St~Pad
  | DrawBall St~Ball
  | DrawBlocks St~Blocks
    # | DrawLives St~Lives
  )
)
