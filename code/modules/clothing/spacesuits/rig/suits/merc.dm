/obj/item/clothing/head/helmet/space/rig/merc
	light_overlay = "helmet_light_dual_green"
	camera_networks = list(NETWORK_MERCENARY)
	light_color = "#3e7c3e"

/obj/item/weapon/rig/merc
	name = "crimson hardsuit control module"
	desc = "A blood-red hardsuit featuring some fairly illegal technology."
	icon_state = "merc_rig"
	suit_type = "crimson hardsuit"
	armor = list(melee = 80, bullet = 65, laser = 50, energy = 15, bomb = 80, bio = 100, rad = 60)
	siemens_coefficient = 0.1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	emp_protection = 30

	helm_type = /obj/item/clothing/head/helmet/space/rig/merc
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,/obj/item/weapon/material/twohanded/fireaxe)

	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/actuators/combat
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

//Has most of the modules removed
/obj/item/weapon/rig/merc/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite, //might as well
		/obj/item/rig_module/actuators/combat // What the dude above me said.
		)

/obj/item/weapon/rig/merc/distress
	req_access = list(access_distress)
