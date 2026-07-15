# Game theory evolution simulation

I was wandering, how to make a classical game theory problem more simular to life. So in this case players die when they are betrayed, and the winner reproduced, passing their genes. I also added mutations to see what the system will evolve into.

## Coefficients
- carma - EMA (Exponential Moving Average) coefficient that shows reputation of a player. This is the magic component, that adds space for different strategies.
- maybe i will also add luck here but i really don't convolute this, so for it is all.

## There are several types of genes: 
---
- defection - main property, which defines how likely is this player to betray someone
- trust - how how important is opponents carma
- alpha - not a gene per se, but a coefficient that shows how fast karma can change. I thought it would be fun to make it a gene too. It acts like a likability or luck parameter.
- mut_step - how much evolution are we talking about. Cool that this parameter is also changable