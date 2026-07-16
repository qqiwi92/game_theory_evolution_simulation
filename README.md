# Game theory evolution simulation

I was wondering, how to make a classical game theory problem more similar to life. So in this case players die when they are betrayed, and the winner reproduces, passing their genes. I also added mutations to see what the system will evolve into.

## Coefficients
- karma - EMA (Exponential Moving Average) coefficient that shows reputation of a player. This is the magic component, that adds space for different strategies. 0 is a not cooperative at all, 1 is always cooperative.
- age - nto prevent exponential growth
- maybe I will also add luck here but I really don't convolute this, so that's all for now.

## There are several types of genes:
- defection - main property, which defines how likely is this player to betray someone
- trust - how important is opponent's karma
- alpha - not a gene per se, but a coefficient that shows how fast karma can change. I thought it would be fun to make it a gene too. It acts like a likeability or luck parameter.
- mut_step - how much evolution are we talking about. Cool that this parameter is also changeable
- longevity - to prevent exponential growth


## Results
In the first iterions i had dull results with only selfish strategies surviving through time. I had to tweak the reward to get results like these. Here we see drastic changes in pretty short period of time - the behavior changes drasticly - my hypothesis is that this is the closest to tit for tat strategy (arguably the optimal one) that can be achieved without sequential interactions between players.
<img width="932" height="1009" alt="image" src="https://github.com/user-attachments/assets/e398ba81-5704-4d5d-96d4-f749ba14e15c" />


<img width="932" height="1009" alt="image" src="https://github.com/user-attachments/assets/241f236f-a417-4438-95dc-9287d504ef41" />
