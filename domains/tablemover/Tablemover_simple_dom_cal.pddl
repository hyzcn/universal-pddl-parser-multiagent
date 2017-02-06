; simplified version of the tablemover domain
(define (domain tablemover)
(:requirements :equality :typing :conditional-effects :multi-agent)
(:types agent block table - locatable
		locatable room side)
(:constants Table - table)
(:predicates
	(on-table ?b - block)
	(on-floor ?b - block)
	(down ?s - side)
	(up ?s - side)
	(clear ?s - side)
	(at-side ?a - agent ?s - side)
	(lifting ?a - agent ?s - side)
	(inroom ?l - locatable ?r - room)
	(available ?a - agent)
	(handempty ?a - agent)
	(holding ?a - agent ?b - block)
	(connected ?r1 ?r2 - room)
)
(:concurrent
	(pickup-floor ?a - agent ?b - block ?r - room)
	(putdown-floor ?a - agent ?b - block ?r - room)
	(pickup-table ?a - agent ?b - block ?r - room)
	(putdown-table ?a - agent ?b - block ?r - room)
	(to-table ?a - agent ?r - room ?s - side)
	(leave-table ?a - agent ?s - side)
	(move-agent ?a - agent ?r1 ?r2 - room)
	(move-table ?a - agent ?r1 ?r2 - room ?s - side)
	(lift-side ?a - agent ?s - side)
	(lower-side ?a - agent ?s - side)
)
(:action pickup-floor
	:parameters (?a - agent ?b - block ?r - room)
	:precondition (and
					(on-floor ?b)
					(inroom ?a ?r)
					(inroom ?b ?r)
					(available ?a)
					(handempty ?a)
					(forall (?a2 - agent) (not (pickup-floor ?a2 ?b ?r)))
				  )
	:effect	(and
					(not (on-floor ?b))
					(not (inroom ?b ?r))
					(not (handempty ?a))
					(holding ?a ?b)
				 )
)
(:action putdown-floor
	:parameters (?a - agent ?b - block ?r - room)
	:precondition (and
					(available ?a)
					(inroom ?a ?r)
					(holding ?a ?b)
				  )
	:effect	(and
					(on-floor ?b)
					(inroom ?b ?r)
					(handempty ?a)
					(not (holding ?a ?b))
				 )
)
(:action pickup-table
	:parameters (?a - agent ?b - block ?r - room)
	:precondition (and
					(on-table ?b)
					(inroom ?a ?r)
					(inroom Table ?r)
					(available ?a)
					(handempty ?a)
					(forall (?a2 - agent) (not (pickup-table ?a2 ?b ?r)))
				  )
	:effect	(and
					(not (on-table ?b))
					(not (handempty ?a))
					(holding ?a ?b)
				 )
)
(:action putdown-table
	:parameters (?a - agent ?b - block ?r - room)
	:precondition (and
					(inroom ?a ?r)
					(inroom Table ?r)
					(available ?a)
					(holding ?a ?b)
					; check table not lifted
					(forall (?s - side)
									(down ?s)
					)
					; check table not intended to be lifted!
					(forall (?a2 - agent ?s - side) (not (lift-side ?a2 ?s)))
				  )
	:effect	(and
					(on-table ?b)
					(handempty ?a)
					(not (holding ?a ?b))
				 )
)
(:action to-table
	:parameters (?a - agent ?r - room ?s - side)
	:precondition (and
					(clear ?s)
					(inroom ?a ?r)
					(inroom Table ?r)
					(available ?a)
					(forall (?a2 - agent) (not (to-table ?a2 ?r ?s)))
				  )
	:effect	(and
					(not (clear ?s))
					(at-side ?a ?s)
					(not (available ?a))
				 )
)
(:action leave-table
	:parameters (?a - agent ?s - side)
	:precondition (and
					(at-side ?a ?s)
					(not (lifting ?a ?s))
				  )
	:effect	(and
					(clear ?s)
					(not (at-side ?a ?s))
					(available ?a)
				 )
)
(:action move-agent
	:parameters (?a - agent ?r1 ?r2 - room)
	:precondition (and
									(inroom ?a ?r1)
									(connected ?r1 ?r2)
				  			)
	:effect	(and
						(not (inroom ?a ?r1))
						(inroom ?a ?r2)
				 	)
)
(:action move-table
	:parameters (?a - agent ?r1 ?r2 - room ?s - side)
	:precondition (and
					(lifting ?a ?s)
					(inroom ?a ?r1)
					(connected ?r1 ?r2)
					(exists (?a2 - agent ?s2 - side) (and (not (= ?s ?s2)) (move-table ?a2 ?r1 ?r2 ?s2)))
				  )
	:effect	(and
					(not (inroom ?a ?r1))
					(not (inroom Table ?r1))
					(inroom ?a ?r2)
					(inroom Table ?r2)
				 )
)
(:action lift-side
	:parameters (?a - agent ?s - side)
	:precondition (and
					(down ?s)
					(at-side ?a ?s)
					(handempty ?a)
					(forall (?a2 - agent ?s2 - side) (not (lower-side ?a2 ?s2)))
				  )
	:effect	(and
					(not (down ?s))
					(up ?s)
					(lifting ?a ?s)
					(not (handempty ?a))
					(forall (?b - block ?r - room ?s2 - side) (when (and (inroom Table ?r) (on-table ?b) (down ?s2) (forall (?a2 - agent) (not (lift-side ?a2 ?s2))))
																	(and (on-floor ?b) (inroom ?b ?r) (not (on-table ?b)))))
				 )
)
(:action lower-side
	:parameters (?a - agent ?s - side)
	:precondition (and
					(lifting ?a ?s)
					(forall (?a2 - agent ?s2 - side) (not (lift-side ?a2 ?s2)))
				  )
	:effect	(and
					(down ?s)
					(not (up ?s))
					(not (lifting ?a ?s))
					(handempty ?a)
					(forall (?b - block ?r - room ?s2 - side) (when (and (inroom Table ?r) (on-table ?b) (up ?s2) (forall (?a2 - agent) (not (lower-side ?a2 ?s2))))
																	(and (on-floor ?b) (inroom ?b ?r) (not (on-table ?b)))))
				 )
)
)
