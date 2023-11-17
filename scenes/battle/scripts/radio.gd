extends Node

 
# Overall Battle Related
signal start_battle(battle_data : BattleData)

# Deck Related
signal draw_card(card_data : CardData)


# Hand Related
signal hand_is_full
