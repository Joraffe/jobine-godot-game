extends Resource
class_name Stack


# first in
# last out
var _stack = []


func push(item) -> void:
	self._stack.append(item)

func pop():
	return self._stack.pop_back()

func size():
	return self._stack.size()

func is_empty():
	return self._stack.size() == 0

func empty():
	self._stack = []
