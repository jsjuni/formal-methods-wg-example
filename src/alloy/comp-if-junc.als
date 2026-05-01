abstract sig Thing {}

abstract sig Component extends Thing {
	c_presents: some MechInterface
}

sig Router extends Component {}

sig PowerCable extends Component {}

abstract sig Interface extends Thing {
	i_presents: set Interface
}

abstract sig MechInterface extends Interface {}

fact elec_pres_by_mech {
	all e : ElecInterface | e.~i_presents in MechInterface
}

abstract sig C13_Interface extends MechInterface {}

sig C13_Male extends C13_Interface {}

sig C13_Female extends C13_Interface {}

fact lone_c13_male_per_router {
	all r : Router | one r.(c_presents :> C13_Male)
	all r : Router | no r.(c_presents :> C13_Female)
}

fact power_cable_female_end_only {
	all c : PowerCable | no c.(c_presents :> C13_Male)
	all c : PowerCable | one c.(c_presents :> C13_Female)
}

abstract sig ElecInterface extends Interface {}

abstract sig Us120Vac_Interface extends ElecInterface {}

sig Us120Vac_Load extends Us120Vac_Interface {}

fact c13_male_is_load {
	all p : C13_Male | one p.(i_presents :> Us120Vac_Load)
	all p : C13_Male | no p.(i_presents :> Us120Vac_Source)
}

fact c13_female_is_load {
	all p : C13_Female | no p.(i_presents :> Us120Vac_Load)
	all p : C13_Female | one p.(i_presents :> Us120Vac_Source)
}

fact c_13_pres_by_component {
	all c : C13_Interface | no c.~i_presents
}

sig Us120Vac_Source extends Us120Vac_Interface {
}

fact one_UsVac_per_C13 {
	all c : C13_Interface | one c.(i_presents :> Us120Vac_Interface)
}

abstract sig Junction extends Thing {
	joins1: one Interface,
	joins2: one Interface
}

sig C13_Junction extends Junction {
}

sig Us120Vac_Junction extends Junction {}

fact i_presents_inverse_functional {
	i_presents.~i_presents in iden
}

fact interface_joined {
	all i : Interface | one (joins1.i + joins2.i)
}

fact i_presents_acyclic {
	all i : Interface | i not in i.^i_presents
}

fact single_presenter {
	all i : Interface | one c_presents.i + i_presents.i
}

fact c13_junction_conj {
	all j : C13_Junction | j.joins1 in C13_Male
	all j : C13_Junction | j.joins2 in C13_Female
}

fact us120vac_junction_conj {
	all j : Us120Vac_Junction | j.joins1 in Us120Vac_Load
	all j : Us120Vac_Junction | j.joins2 in Us120Vac_Source
}

fact joins_inverse_functional {
	joins1.~joins1 + joins2.~joins2 in iden
}

run example {} for 8 but exactly 1 Router, exactly 1 PowerCable//, exactly 1 C13_Junction, exactly 1 Us120Vac_Junction

