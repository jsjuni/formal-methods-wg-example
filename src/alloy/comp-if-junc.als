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

fact all_interfaces_joined {
	all i : Interface | interface_joined[i]
}

pred junction_joins_two [ j : Junction ] {
	#j.~is_joined_in >= 2
}

fact all_junctions_join_two {
	all j : Junction | junction_joins_two[j]
}

pred example {}

run example for 8 but exactly 2 Junction

//check all_interfaces_presented for 8 but exactly 2 Junction

//check all_interfaces_joined for 8 but exactly 2 Junction

//check all_junctions_join_two for 8 but exactly 2 Junction

