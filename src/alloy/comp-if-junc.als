abstract sig Thing {}

//
//
// Presenter
//
//

abstract sig Presenter extends Thing {
	presents: set Interface
}

fact presents_inverse_functional {
	presents.~presents in iden
}

fact presents_acyclic {
	all i : Interface | i not in i.^presents
}

//
//
// Component
//
//

sig Component extends Presenter {}

//
//
// Interface
//
//

sig Interface extends Presenter {
	is_joined_in: lone Junction
}

//
//
// Junction
//
//

sig Junction extends Thing {}

//
//
// Pruning Constraints
//
//

pred presents_chain_limited [ i : Interface ] {
	lone i.^presents
}

fact all_presents_chains_limited {
	all i : Interface | presents_chain_limited[i]
}

pred junction_at_equal_depth [ j : Junction ] {
	all disj i1, i2 : j.~is_joined_in | #i1.^~presents = #i2.^~presents
}

fact all_junctions_at_equal_depth {
	all j : Junction | junction_at_equal_depth[j]
}

fun joined_components(j : Junction) : set Component {
	j.~is_joined_in.^~presents & Component
}

fact connected_example {
	all disj j1, j2 : Junction | joined_components[j1] = joined_components[j2]
}

//
//
// Completeness Constraints
//
//

pred component_presents [ c : Component ] {
	some c.presents
}

fact all_components_present {
	all c : Component | component_presents[c]
}

pred interface_presented [ i : Interface ] {
	some presents.i
}

fact all_interfaces_presented {
	all i : Interface | interface_presented[i]
}

pred interface_joined [ i : Interface ] {
	some i.is_joined_in
}

assert all_interfaces_joined {
	all i : Interface | interface_joined[i]
}

pred junction_joins_two [ j : Junction ] {
	#j.~is_joined_in >= 2
}

fact all_junctions_join_two {
	all j : Junction | junction_joins_two[j]
}

pred example {}

run example for 10 but exactly 2 Junction

check all_interfaces_joined for 8
