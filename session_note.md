## 11/22/2024, 27:00.

I just finished adding some furniture icons that are adjusted.
What you need to do:
  - Integrate the shop to the inventory.
    - Basically, use the cash if available.
    - Buy the item.
    - Also display the item in the shop. Currently it's all placeholders.
      - I think there's also still some pages where the cash is still placeholder. "Broke ahh" or whatnot.
  - Add basic room expansion. I think you don't have time to create multiple rooms.
    - That's fine.
  - Add pet changing system. Probably a customization in the inventory? Maybe add tabs?
    - For the pet gachapon, what if you just make it like a random roll?
    - I don't know how to implement that, but like I'm currently thinking:
      - For 50 ticks, random fast boxes.
      - For 20 ticks, it's random slow boxes. (It may skip for some randomness.)
      - Then for 5 ticks, it's slow. 
      - Then huzzah.

After all of these, then we can say this AppDev project is now an MVP.

## 11/23/2024 11:00AM

TODO:
- [x] Integrate the shop with the cash system.

### 11:30PM

I was not successful in implementing the gachapon system. The caveats are few however.
First: just add some pets to the system.
Next: Do the animation thing. Follow my previous advice. 50 ticks of random fast boxes, 20 ticks of slow boxes.

Next, add a tab to the inventory panel. Please. For now, just add the list of owned pets, and:
  on click of the pet, we change the pet in the room. On commit (click of the blue wrench),
  we save it to the database.

Food system: I have no clue what to do.
