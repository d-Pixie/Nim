block: # Replicates #18728
  type
    FlipFlop[A, B] = ref object
      val: A
      next: FlipFlop[B, A]
  
    Trinary[A, B, C] = ref object
      next: Trinary[B, C, A]
  
  assert typeof(FlipFlop[int, string]().next) is FlipFlop[string, int]
  assert typeof(FlipFlop[string, int]().next) is FlipFlop[int, string]
  assert typeof(Trinary[int, float, string]().next) is Trinary[float, string, int]
  assert typeof(Trinary[int, float, string]().next.next) is Trinary[string, int, float]
  var a = FlipFlop[int, string](val: 100, next: FlipFlop[string, int](val: "Hello"))
  assert a.val == 100
  assert a.next.val == "Hello"

block: # 18838
  type
    DoublyLinkedNodeObj[T] = object
      value: T

    DoublyLinkedNode[T] = ref DoublyLinkedNodeObj[T]

    Item[T] = ref object
      link: DoublyLinkedNode[Item[T]]

    Box = object

  proc newDoublyLinkedNode[T](value: T): DoublyLinkedNode[T] =
    new(result)
    result.value = value 

  let link = newDoublyLinkedNode(Item[Box]())

import lists
block:
  type
    Box = object
    Item[T] = ref object
      link:DoublyLinkedNode[ Item[T] ]

    ItemSimple = ref object
      link:DoublyLinkedNode[ ItemSimple ]

  let link = newDoublyLinkedNode( Item[Box]() )