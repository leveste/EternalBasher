FunctionCallForResources() { 
	if ( $___OWNS_CAMPAIGN = false ); then goto "FunctionCallForResourcesPostCampaignA"; fi
	
	$1 game/sp/e1m1_intro/e1m1_intro                               e1m1_intro
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e1m1_intro/e1m1_intro_patch1                        e1m1_intro_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e1m1_intro/e1m1_intro_patch2                        e1m1_intro_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e1m2_battle/e1m2_battle                             e1m2_battle
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e1m2_battle/e1m2_battle_patch1                      e1m2_battle_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e1m2_battle/e1m2_battle_patch2                      e1m2_battle_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e1m3_cult/e1m3_cult                                 e1m3_cult
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e1m3_cult/e1m3_cult_patch1                          e1m3_cult_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e1m3_cult/e1m3_cult_patch2                          e1m3_cult_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e1m4_boss/e1m4_boss                                 e1m4_boss
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e1m4_boss/e1m4_boss_patch1                          e1m4_boss_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e1m4_boss/e1m4_boss_patch2                          e1m4_boss_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e2m1_nest/e2m1_nest                                 e2m1_nest
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e2m1_nest/e2m1_nest_patch1                          e2m1_nest_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e2m1_nest/e2m1_nest_patch2                          e2m1_nest_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e2m2_base/e2m2_base                                 e2m2_base
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e2m2_base/e2m2_base_patch1                          e2m2_base_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e2m2_base/e2m2_base_patch2                          e2m2_base_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e2m3_core/e2m3_core                                 e2m3_core
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e2m3_core/e2m3_core_patch1                          e2m3_core_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e2m3_core/e2m3_core_patch2                          e2m3_core_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e2m4_boss/e2m4_boss                                 e2m4_boss
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e2m4_boss/e2m4_boss_patch1                          e2m4_boss_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m1_slayer/e3m1_slayer                             e3m1_slayer
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m1_slayer/e3m1_slayer_patch1                      e3m1_slayer_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m1_slayer/e3m1_slayer_patch2                      e3m1_slayer_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m2_hell/e3m2_hell                                 e3m2_hell
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m2_hell/e3m2_hell_patch1                          e3m2_hell_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m2_hell/e3m2_hell_patch2                          e3m2_hell_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m2_hell_b/e3m2_hell_b                             e3m2_hell_b
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m2_hell_b/e3m2_hell_b_patch1                      e3m2_hell_b_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m2_hell_b/e3m2_hell_b_patch2                      e3m2_hell_b_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m3_maykr/e3m3_maykr                               e3m3_maykr
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m3_maykr/e3m3_maykr_patch1                        e3m3_maykr_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m3_maykr/e3m3_maykr_patch2                        e3m3_maykr_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m4_boss/e3m4_boss                                 e3m4_boss
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m4_boss/e3m4_boss_patch1                          e3m4_boss_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/sp/e3m4_boss/e3m4_boss_patch2                          e3m4_boss_patch2
	if [[ $? != 0 ]]; then return 1; fi
	
}


FunctionCallForResourcesPostCampaignA(){
	if [[ $___OWNS_ANCIENT_GODS_ONE = false ]]; then goto "FunctionCallForResourcesPostAncientGodsOneA"; fi

	$1 game/dlc/e4m1_rig/e4m1_rig                                  e4m1_rig
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/dlc/e4m1_rig/e4m1_rig_patch1                           e4m1_rig_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/dlc/e4m1_rig/e4m1_rig_patch2                           e4m1_rig_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/dlc/e4m2_swamp/e4m2_swamp                              e4m2_swamp
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/dlc/e4m2_swamp/e4m2_swamp_patch1                       e4m2_swamp_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/dlc/e4m2_swamp/e4m2_swamp_patch2                       e4m2_swamp_patch2
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/dlc/e4m3_mcity/e4m3_mcity                              e4m3_mcity
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/dlc/e4m3_mcity/e4m3_mcity_patch1                       e4m3_mcity_patch1
	if [[ $? != 0 ]]; then return 1; fi
}

FunctionCallForResourcesPostAncientGodsOneA(){
	$1 gameresources                                               gameresources
	if [[ $? != 0 ]]; then return 1; fi
	$1 gameresources_patch1                                        gameresources_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 gameresources_patch2                                        gameresources_patch2
	if [[ $? != 0 ]]; then return 1; fi
	
	if [[ $___OWNS_ANCIENT_GODS_ONE = false ]]; then goto "FunctionCallForResourcesPostAncientGodsOneB"; fi

	$1 game/dlc/hub/hub                                            dlc_hub
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/dlc/hub/hub_patch1                                     dlc_hub_patch1
	if [[ $? != 0 ]]; then return 1; fi
}

FunctionCallForResourcesPostAncientGodsOneB(){
	if [[ $___OWNS_CAMPAIGN = false ]]; then goto "FunctionCallForResourcesPostCampaignB"; fi

	$1 game/hub/hub                                                hub
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/hub/hub_patch1                                         hub_patch1
	if [[ $? != 0 ]]; then return 1; fi
}

FunctionCallForResourcesPostCampaignB(){
	$1 meta                                                        meta
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_bronco/pvp_bronco                              pvp_bronco
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_bronco/pvp_bronco_patch1                       pvp_bronco_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_deathvalley/pvp_deathvalley                    pvp_deathvalley
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_deathvalley/pvp_deathvalley_patch1             pvp_deathvalley_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_inferno/pvp_inferno                            pvp_inferno
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_inferno/pvp_inferno_patch1                     pvp_inferno_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_laser/pvp_laser                                pvp_laser
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_laser/pvp_laser_patch1                         pvp_laser_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_shrapnel/pvp_shrapnel                          pvp_shrapnel
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_shrapnel/pvp_shrapnel_patch1                   pvp_shrapnel_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_thunder/pvp_thunder                            pvp_thunder
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_thunder/pvp_thunder_patch1                     pvp_thunder_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_zap/pvp_zap                                    pvp_zap
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/pvp/pvp_zap/pvp_zap_patch1                             pvp_zap_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/shell/shell                                            shell
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/shell/shell_patch1                                     shell_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/tutorials/tutorial_demons                              tutorial_demons
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/tutorials/tutorial_pvp_laser/tutorial_pvp_laser        tutorial_pvp_laser
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/tutorials/tutorial_pvp_laser/tutorial_pvp_laser_patch1 tutorial_pvp_laser_patch1
	if [[ $? != 0 ]]; then return 1; fi
	$1 game/tutorials/tutorial_sp                                  tutorial_sp
	if [[ $? != 0 ]]; then return 1; fi
	$1 warehouse                                                   warehouse
	if [[ $? != 0 ]]; then return 1; fi
}