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

abstract sig Component extends Presenter {}

//
// Router
//

sig Router extends Component {}

fact router_presents_one_c13_male {
	all r : Router | one r.(presents :> C13_Male)
}

fact router_presents_no_c13_female {
	all r : Router | no r.(presents :> C13_Female)
}

//
// PowerCable
//

sig PowerCable extends Component {}

fact power_cable_one_c13_female {
	all c : PowerCable | one c.(presents :> C13_Female)
}

fact power_cable_presents_no_c13_male {
	all c : PowerCable | no c.(presents :> C13_Male)
}

//
//
// Interface
//
//

fact interface_presented {
	all i : Interface | lone presents.i
}

abstract sig Interface extends Presenter {
	is_joined_in: lone Junction
}

//
// Electrical Interface
//

abstract sig ElectricalInterface extends Interface {}

//
// US 120 VAC Interface
//

abstract sig Us120VacInterface extends ElectricalInterface {}

fact us120vac_presented_by_c13 {
	all i : Us120VacInterface | i.^presents in C13Interface
}

fact us120vac_joined_in_us120vac {
	all i : Us120VacInterface | i.is_joined_in in Us120VacJunction
}

// US 120 VAC Load

sig Us120Vac_Load extends Us120VacInterface {}

fact us120vac_load_presented_by_c13_male {
	all i : Us120Vac_Load | i.^presents in C13_Male
}

// US 120 VAC Source

sig Us120Vac_Source extends Us120VacInterface {}

fact us120vac_source_presented_by_c13_female {
	all i : Us120Vac_Source | i.^presents in C13_Female
}

//
// Mechanical Interface
//

abstract sig MechanicalInterface extends Interface {}

//
// C13 Interface
//

abstract sig C13Interface extends MechanicalInterface {}

fact c13_presents_us120vac {
	all i : C13Interface | i.presents in Us120VacInterface
}

fact c13_joined_in_c13 {
	all i : C13Interface | i.is_joined_in in C13Junction
}

// C13 Male

sig C13_Male extends C13Interface {}

fact c13_male_presents_one {
	all i : C13_Male | (one i.presents)
}

fact c13_male_presents_us120vac_load {
	all i : C13_Male | i.presents in Us120Vac_Load
}

// C13 Female

sig C13_Female extends C13Interface {}

fact c13_female_presents_one {
	all i : C13_Female | one i.presents
}

fact c13_female_us120vac_source {
	all i : C13_Female | i.presents in Us120Vac_Source
}

//
//
// Junction
//
//

abstract sig Junction extends Thing {}

// C13 Junction

sig C13Junction extends Junction {}

fact c13_junction_mail {
	all j : C13Junction | lone j.(~is_joined_in :> C13_Male)
}

fact c13_junction_female {
	all j : C13Junction | lone j.(~is_joined_in :> C13_Female)
}

// US 120 VAC Junction

sig Us120VacJunction extends Junction {}

fact us120vac_junction_load {
	all j : Us120VacJunction | lone j.(~is_joined_in :> Us120Vac_Load)
}

fact us120vac_junction_source {
	all j : Us120VacJunction | lone j.(~is_joined_in :> Us120Vac_Source)
}

//
//
// Completeness Constraints
//
//

fact all_interfaces_presented {
	all i : Interface | one presents.i
}

fact all_interfaces_joined {
	all i : Interface | one i.is_joined_in
}

run example {} for 16 but exactly 2 Router, exactly 2 PowerCable

