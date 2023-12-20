extends Resource
class_name Queue


# first in
# first out
var queue = []


func enqueue(item) -> void:
	self.queue.append(item)

func dequeue():
	return self.queue.pop_front()

func size() -> int:
	return self.queue.size()

func is_empty() -> bool:
	return self.size() == 0

func empty() -> void:
	self.queue = []
