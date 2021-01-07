FunctionCallForResources(){ 
	if ( $___OWNS_CAMPAIGN = false ); then goto "FunctionCallForResourcesPostCampaignA"
	fi
	
	$1 game/sp/e1m1_intro/e1m1_intro                               e1m1_intro
	if ($? != 0); then return 1; fi
	$1 game/sp/e1m1_intro/e1m1_intro_patch1                        e1m1_intro_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e1m1_intro/e1m1_intro_patch2                        e1m1_intro_patch2
	if ($? != 0); then return 1; fi
	$1 game/sp/e1m2_battle/e1m2_battle                             e1m2_battle
	if ($? != 0); then return 1; fi
	$1 game/sp/e1m2_battle/e1m2_battle_patch1                      e1m2_battle_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e1m2_battle/e1m2_battle_patch2                      e1m2_battle_patch2
	if ($? != 0); then return 1; fi
	$1 game/sp/e1m3_cult/e1m3_cult                                 e1m3_cult
	if ($? != 0); then return 1; fi
	$1 game/sp/e1m3_cult/e1m3_cult_patch1                          e1m3_cult_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e1m3_cult/e1m3_cult_patch2                          e1m3_cult_patch2
	if ($? != 0); then return 1; fi
	$1 game/sp/e1m4_boss/e1m4_boss                                 e1m4_boss
	if ($? != 0); then return 1; fi
	$1 game/sp/e1m4_boss/e1m4_boss_patch1                          e1m4_boss_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e1m4_boss/e1m4_boss_patch2                          e1m4_boss_patch2
	if ($? != 0); then return 1; fi
	$1 game/sp/e2m1_nest/e2m1_nest                                 e2m1_nest
	if ($? != 0); then return 1; fi
	$1 game/sp/e2m1_nest/e2m1_nest_patch1                          e2m1_nest_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e2m1_nest/e2m1_nest_patch2                          e2m1_nest_patch2
	if ($? != 0); then return 1; fi
	$1 game/sp/e2m2_base/e2m2_base                                 e2m2_base
	if ($? != 0); then return 1; fi
	$1 game/sp/e2m2_base/e2m2_base_patch1                          e2m2_base_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e2m2_base/e2m2_base_patch2                          e2m2_base_patch2
	if ($? != 0); then return 1; fi
	$1 game/sp/e2m3_core/e2m3_core                                 e2m3_core
	if ($? != 0); then return 1; fi
	$1 game/sp/e2m3_core/e2m3_core_patch1                          e2m3_core_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e2m3_core/e2m3_core_patch2                          e2m3_core_patch2
	if ($? != 0); then return 1; fi
	$1 game/sp/e2m4_boss/e2m4_boss                                 e2m4_boss
	if ($? != 0); then return 1; fi
	$1 game/sp/e2m4_boss/e2m4_boss_patch1                          e2m4_boss_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m1_slayer/e3m1_slayer                             e3m1_slayer
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m1_slayer/e3m1_slayer_patch1                      e3m1_slayer_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m1_slayer/e3m1_slayer_patch2                      e3m1_slayer_patch2
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m2_hell/e3m2_hell                                 e3m2_hell
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m2_hell/e3m2_hell_patch1                          e3m2_hell_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m2_hell/e3m2_hell_patch2                          e3m2_hell_patch2
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m2_hell_b/e3m2_hell_b                             e3m2_hell_b
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m2_hell_b/e3m2_hell_b_patch1                      e3m2_hell_b_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m2_hell_b/e3m2_hell_b_patch2                      e3m2_hell_b_patch2
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m3_maykr/e3m3_maykr                               e3m3_maykr
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m3_maykr/e3m3_maykr_patch1                        e3m3_maykr_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m3_maykr/e3m3_maykr_patch2                        e3m3_maykr_patch2
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m4_boss/e3m4_boss                                 e3m4_boss
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m4_boss/e3m4_boss_patch1                          e3m4_boss_patch1
	if ($? != 0); then return 1; fi
	$1 game/sp/e3m4_boss/e3m4_boss_patch2                          e3m4_boss_patch2
	if ($? != 0); then return 1; fi
	
}
