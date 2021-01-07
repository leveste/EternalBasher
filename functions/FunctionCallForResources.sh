<<<<<<< HEAD
FunctionCallForResources(){ 
	if ( $___OWNS_CAMPAIGN = false ); then FunctionCallForResourcesPostCampaignA
	fi
	
	CALL %1 game\sp\e1m1_intro\e1m1_intro                               e1m1_intro
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e1m1_intro\e1m1_intro_patch1                        e1m1_intro_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e1m1_intro\e1m1_intro_patch2                        e1m1_intro_patch2
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e1m2_battle\e1m2_battle                             e1m2_battle
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e1m2_battle\e1m2_battle_patch1                      e1m2_battle_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e1m2_battle\e1m2_battle_patch2                      e1m2_battle_patch2
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e1m3_cult\e1m3_cult                                 e1m3_cult
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e1m3_cult\e1m3_cult_patch1                          e1m3_cult_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e1m3_cult\e1m3_cult_patch2                          e1m3_cult_patch2
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e1m4_boss\e1m4_boss                                 e1m4_boss
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e1m4_boss\e1m4_boss_patch1                          e1m4_boss_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e1m4_boss\e1m4_boss_patch2                          e1m4_boss_patch2
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e2m1_nest\e2m1_nest                                 e2m1_nest
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e2m1_nest\e2m1_nest_patch1                          e2m1_nest_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e2m1_nest\e2m1_nest_patch2                          e2m1_nest_patch2
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e2m2_base\e2m2_base                                 e2m2_base
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e2m2_base\e2m2_base_patch1                          e2m2_base_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e2m2_base\e2m2_base_patch2                          e2m2_base_patch2
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e2m3_core\e2m3_core                                 e2m3_core
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e2m3_core\e2m3_core_patch1                          e2m3_core_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e2m3_core\e2m3_core_patch2                          e2m3_core_patch2
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e2m4_boss\e2m4_boss                                 e2m4_boss
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e2m4_boss\e2m4_boss_patch1                          e2m4_boss_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m1_slayer\e3m1_slayer                             e3m1_slayer
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m1_slayer\e3m1_slayer_patch1                      e3m1_slayer_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m1_slayer\e3m1_slayer_patch2                      e3m1_slayer_patch2
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m2_hell\e3m2_hell                                 e3m2_hell
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m2_hell\e3m2_hell_patch1                          e3m2_hell_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m2_hell\e3m2_hell_patch2                          e3m2_hell_patch2
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m2_hell_b\e3m2_hell_b                             e3m2_hell_b
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m2_hell_b\e3m2_hell_b_patch1                      e3m2_hell_b_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m2_hell_b\e3m2_hell_b_patch2                      e3m2_hell_b_patch2
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m3_maykr\e3m3_maykr                               e3m3_maykr
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m3_maykr\e3m3_maykr_patch1                        e3m3_maykr_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m3_maykr\e3m3_maykr_patch2                        e3m3_maykr_patch2
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m4_boss\e3m4_boss                                 e3m4_boss
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m4_boss\e3m4_boss_patch1                          e3m4_boss_patch1
	IF ERRORLEVEL 1 EXIT /B 1
	CALL %1 game\sp\e3m4_boss\e3m4_boss_patch2                          e3m4_boss_patch2
	IF ERRORLEVEL 1 EXIT /B 1
	
}
=======
function FunctionCallForResources() {
 if [ $___OWNS_CAMPAIGN = false ]; then
 
>>>>>>> 5b5d34b6fb517174815f42c2e35f13877dc9d666
