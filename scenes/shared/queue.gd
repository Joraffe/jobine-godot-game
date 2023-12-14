extends Resource
class_name Queue


# first in
# first out
var queue = []


func enqueue(item) -> void:
	self.queue.append(item)


func dequeue():
	return self.queue.pop_front()
