extends Resource
class_name ArrayUtils


static func to_indexes(array : Array[Variant]) -> Array:
	var indexes : Array = []

	for i in array.size():
		indexes.append(i)

	return indexes


static func difference(arr1 : Array, arr2 : Array) -> Array:
	var in_2_but_not_1 : Array = []
	for val in arr2:
		if val not in arr1:
			in_2_but_not_1.append(val)

	return in_2_but_not_1
