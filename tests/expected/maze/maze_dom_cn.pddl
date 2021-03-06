( DEFINE ( DOMAIN MAZE )
( :REQUIREMENTS :TYPING :MULTI-AGENT :CONCURRENCY-NETWORK )
( :TYPES
	AGENT - OBJECT
	LOCATION - OBJECT
	DOOR - OBJECT
	BRIDGE - OBJECT
	BOAT - OBJECT
	SWITCH - OBJECT
)
( :PREDICATES
	( AT ?AGENT0 - AGENT ?LOCATION1 - LOCATION )
	( HAS-SWITCH ?SWITCH0 - SWITCH ?LOCATION1 - LOCATION ?LOCATION2 - LOCATION ?LOCATION3 - LOCATION )
	( BLOCKED ?LOCATION0 - LOCATION ?LOCATION1 - LOCATION )
	( HAS-DOOR ?DOOR0 - DOOR ?LOCATION1 - LOCATION ?LOCATION2 - LOCATION )
	( HAS-BOAT ?BOAT0 - BOAT ?LOCATION1 - LOCATION ?LOCATION2 - LOCATION )
	( HAS-BRIDGE ?BRIDGE0 - BRIDGE ?LOCATION1 - LOCATION ?LOCATION2 - LOCATION )
)
( :ACTION MOVE
  :AGENT ?AGENT - AGENT
  :PARAMETERS ( ?DOOR1 - DOOR ?LOCATION2 - LOCATION ?LOCATION3 - LOCATION )
  :PRECONDITION
	( AND
		( AT ?AGENT ?LOCATION2 )
		( NOT ( BLOCKED ?LOCATION2 ?LOCATION3 ) )
		( HAS-DOOR ?DOOR1 ?LOCATION2 ?LOCATION3 )
	)
  :EFFECT
	( AND
		( AT ?AGENT ?LOCATION3 )
		( NOT ( AT ?AGENT ?LOCATION2 ) )
	)
)
( :ACTION ROW
  :AGENT ?AGENT - AGENT
  :PARAMETERS ( ?BOAT1 - BOAT ?LOCATION2 - LOCATION ?LOCATION3 - LOCATION )
  :PRECONDITION
	( AND
		( AT ?AGENT ?LOCATION2 )
		( HAS-BOAT ?BOAT1 ?LOCATION2 ?LOCATION3 )
	)
  :EFFECT
	( AND
		( AT ?AGENT ?LOCATION3 )
		( NOT ( AT ?AGENT ?LOCATION2 ) )
	)
)
( :ACTION CROSS
  :AGENT ?AGENT - AGENT
  :PARAMETERS ( ?BRIDGE1 - BRIDGE ?LOCATION2 - LOCATION ?LOCATION3 - LOCATION )
  :PRECONDITION
	( AND
		( AT ?AGENT ?LOCATION2 )
		( HAS-BRIDGE ?BRIDGE1 ?LOCATION2 ?LOCATION3 )
	)
  :EFFECT
	( AND
		( AT ?AGENT ?LOCATION3 )
		( NOT ( AT ?AGENT ?LOCATION2 ) )
		( NOT ( HAS-BRIDGE ?BRIDGE1 ?LOCATION2 ?LOCATION3 ) )
		( NOT ( HAS-BRIDGE ?BRIDGE1 ?LOCATION3 ?LOCATION2 ) )
	)
)
( :ACTION PUSHSWITCH
  :AGENT ?AGENT - AGENT
  :PARAMETERS ( ?SWITCH1 - SWITCH ?LOCATION2 - LOCATION ?LOCATION3 - LOCATION ?LOCATION4 - LOCATION )
  :PRECONDITION
	( AND
		( AT ?AGENT ?LOCATION2 )
		( HAS-SWITCH ?SWITCH1 ?LOCATION2 ?LOCATION3 ?LOCATION4 )
	)
  :EFFECT
	( AND
		( NOT ( BLOCKED ?LOCATION3 ?LOCATION4 ) )
		( NOT ( BLOCKED ?LOCATION4 ?LOCATION3 ) )
	)
)
( :CONCURRENCY-CONSTRAINT V1
  :PARAMETERS ( ?DOOR0 - DOOR )
  :BOUNDS ( 1 1 )
  :ACTIONS ( ( MOVE 1 ) )
)
( :CONCURRENCY-CONSTRAINT V2
  :PARAMETERS ( ?BOAT0 - BOAT ?LOCATION1 - LOCATION )
  :BOUNDS ( 2 INF )
  :ACTIONS ( ( ROW 1 2 ) )
)
( :CONCURRENCY-CONSTRAINT V3
  :PARAMETERS ( ?BRIDGE0 - BRIDGE )
  :BOUNDS ( 1 INF )
  :ACTIONS ( ( CROSS 1 ) )
)
( :CONCURRENCY-CONSTRAINT V4
  :PARAMETERS ( ?SWITCH0 - SWITCH )
  :BOUNDS ( 1 1 )
  :ACTIONS ( ( PUSHSWITCH 1 ) )
)
)
