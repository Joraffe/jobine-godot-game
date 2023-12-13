extends Label


func set_attack_text(enemy_attack : EnemyAttack) -> void:
	text = "{attack}".format({"attack": enemy_attack.human_name})
