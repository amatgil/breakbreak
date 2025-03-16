# Experimental!

I ~ "git:https://github.com/Marcos-cat/iris" ~ Color Draw Key T
Cat ~ "./catppuccin.ua"
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

BallW    ← 10
BallH    ← 10
BallSize ← 0.5

BlockH    ← 20
NumBlocks ← 10
BlockGap  ← 10
MarginH   ← 50
MarginW   ← 30
NumRows   ← 6 # How many lines
PadVel    ← ×i 1/1
BlockColors ← [Cat~Green
               Cat~Yellow
               Cat~Rosewater
               Cat~Lavander
               Cat~Teal]

# Definitions
~Ball [Vel Pos]
~Block {Color Size Pos}
┌─╴BlockInit
  PBlockW ← ÷NumBlocks -×₂MarginW W # PseudoWidth
  BlockW  ← -BlockGap PBlockW

  Xs        ← +MarginW×PBlockW ⇡NumBlocks
  Ys        ↚ ⍢(⊂++BlockH BlockGap⊸⊢|<NumRows⧻) [MarginH]
  Positions ↚ ♭⊞ℂ Xs Ys
  RandomCol ← (⊡⊸(⌊×⚂⧻)BlockColors)
  New       ← ≡(Block RandomCol ℂBlockW BlockH) Positions
└─╴

~St {
  Pad ← ℂ÷₂-PadW W -×2.5PadH H
  Ball ← Ball ˙ℂBallSize ℂ÷₈W ÷₃H
  Blocks ← BlockInit
  Lives ← 3
  Score ← 100
  Status ← Status~Running
}

DrawPad              ← |1.0 I~Draw~Rect Cat~Sapphire ℂPadW PadH                            # ? PadPos
DrawBlocks           ← |1.0 ≡(I~Draw~Rect °{⊙⊙⊙})                                          # ? Blocks
DrawBall             ← |1.0 I~Draw~Rect Cat~Text ℂBallW BallH ⊣                            # ? Ball
DrawLives            ← |1.0 I~Draw~Text Cat~Text 20 ˙ℂ ÷₂MarginW ⊂"Lives: " °⋕             # ? Lives
DrawScore            ← |1.0 I~Draw~Text Cat~Text 20 ˜ℂ ÷₂MarginW ⊸(-⊙W×20⧻) ⊂"Score: " °⋕  # ? Score
IsPadBallCollision   ← |2 I~Collide~Rects ⊓(˜⊂ℂPadW PadH|˜⊂ℂ BallW BallH⊣)                 # ? PadPos Ball
IsBallBlockCollision ← |2 I~Collide~Rects ⊓(⊂⊃(Block~Pos|Block~Size)|⊂Ball~Pos ˙ℂBallSize) # b ? Block Ball 

# Ball Blocks Score ? Ball Blocks Score
RunCollisionUpdate ← |3.3 (
  ⊙⊙[]: # blocks ball blockacc score
  # ball blockacc score ? block ball blockacc score
  ∧(◡IsBallBlockCollision
    ⨬(𝄐⌞⊂ # no collision, block to blockacc
    | 𝄐⌞⊂⊙⊙⊙∘
      # 0   # Find axis of collision
      # ⨬(⊓(◌|⍜(⊢Ball~Vel|¯)|∘|+₁)
      # | ⊓(◌|⍜(⊣Ball~Vel|¯)|∘|+₁))
    )
  )
)

# Main
I~Open [W H] "Breakbreak"

St
I~Loop!(
  I~Draw~Background Cat~Base
  ⍥⋅St Key~Down @R # Reset all keybind

  # Inputs
  ⍥⍜St~Pad(↥ 0 -PadVel) Key~Down Key~Arrow @<            # Move left, adjust to bounds
  ⍥⍜St~Pad(↧ ℂ(-PadW W) H +PadVel) Key~Down Key~Arrow @> # Move right, adjust to bounds

  ⍣(⊸(°Status~Running St~Status)
    ⍜(St~Ball|⍜⊣(↧ℂW H ↥0) \+) # Advance ball

    ⍥⍜(St~Ball|⍜⊢⍜°ℂ⊙¯) ⊸(∨⊃(≤0◌°ℂ⊣ St~Ball|IsPadBallCollision ⊃(St~Pad|St~Ball)))
    ⍥⍜(St~Ball|⍜⊢⍜°ℂ¯) ⊸(∨⊃(≤0|≥ -BallW W) ⊙◌°ℂ ⊣ St~Ball)

    ⊸(≥H◌°ℂ⊣ St~Ball) # If ball has exited below
    ⍥(⊸(=₀St~Lives)   # Change state depending on if ≍0 lives 
      ⨬(°⊸St~Ball ⍜⊢⋅0 St~Ball St
        °⊸St~Status Status~Intermission
      | °⊸St~Status Status~Lost)
    )

    # Collision with block
    ⊸(RunCollisionUpdate ⊃(St~Ball|St~Blocks|St~Score))
    ⊙⊙°⊸St~Score
    ⊙°⊸St~Blocks
    °⊸St~Ball
  | ⊸(°Status~Intermission St~Status)
    I~Key~Down I~Key~Space
    ⍥(°⊸St~Ball (St~Ball St)
      °⊸St~Status Status~Running
      ⍜St~Lives-₁
    )
    I~Draw~Text Cat~Text 20 ℂ 10 -₂₀H "Press <SPC> to continue by using a life"
  | ⊸(°Status~Lost St~Status)
    I~Draw~Text Cat~Text 20 ℂ30 -₂₀÷₂ H "You've lost, press R to reset"
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
  | DrawLives St~Lives
  | DrawScore St~Score
  )
)
