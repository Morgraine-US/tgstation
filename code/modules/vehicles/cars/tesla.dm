/obj/vehicle/sealed/car/tesla
	name = "Tesla Model S"
	desc = "Cream Interior. Retractable Sunroof. Infinite Cool."
	icon = 'icons/obj/tesla.dmi'
	icon_state = "tesla"
	max_integrity = 150
	armor = list("melee" = 70, "bullet" = 40, "laser" = 40, "energy" = 0, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 80)
	enter_delay = 20
	max_occupants = 5
	movedelay = 0.6
	key_type = /obj/item/key/tesla
	key_type_exact = FALSE
	pixel_y = -6
	pixel_x = -16
	var/droppingoil = FALSE
	var/crash_all = FALSE //CHAOS

/obj/vehicle/sealed/car/tesla/Initialize()
	. = ..()
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	//D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, -8), TEXT_SOUTH = list(0, 4), TEXT_EAST = list(-10, 5), TEXT_WEST = list( 10, 5)))
	D.set_vehicle_dir_offsets(NORTH, -16, -6)
	D.set_vehicle_dir_offsets(SOUTH, -16, -6)
	D.set_vehicle_dir_offsets(EAST, -16, -6)
	D.set_vehicle_dir_offsets(WEST, -16, -6)

/obj/vehicle/sealed/car/tesla/Bump(atom/movable/M)
	. = ..()
	if(istype(M, /turf/closed))
		visible_message("<span class='warning'>[src] rams into [M] and crashes!</span>")
		playsound(src, pick('sound/vehicles/clowncar_crash1.ogg', 'sound/vehicles/clowncar_crash2.ogg'), 75)
		playsound(src, 'sound/effects/bang.ogg', 75)
		DumpMobs(TRUE)
		log_combat(src, M, "crashed into", null, "dumping all passengers")
	else if(M.density)
		var/atom/throw_target = get_edge_target_turf(M, dir)
		if(crash_all)
			M.throw_at(throw_target, 4, 3)
			visible_message("<span class='danger'>[src] crashes into [M]!</span>")
			playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			H.Paralyze(100)
			H.adjustStaminaLoss(30)
			H.apply_damage(rand(20,35), BRUTE)
			if(!crash_all)
				H.throw_at(throw_target, 4, 3)
				visible_message("<span class='danger'>[src] crashes into [H]!</span>")
				playsound(src, 'sound/effects/bang.ogg', 50, TRUE)

/obj/vehicle/sealed/car/tesla/Destroy()
  playsound(src, 'sound/vehicles/clowncar_fart.ogg', 100)
  return ..()


